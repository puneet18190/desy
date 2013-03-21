class MediaElementsController < ApplicationController
  
  FOR_PAGE_COMPACT = SETTINGS['compact_media_element_pagination']
  FOR_PAGE_COMPACT_OPTIONS = SETTINGS['compact_media_element_pagination_options']
  FOR_PAGE_EXPANDED = SETTINGS['expanded_media_element_pagination']
  FOR_PAGE_EXPANDED_OPTIONS = SETTINGS['expanded_media_element_pagination_options']
  
  before_filter :initialize_media_element, :only => [:add, :remove]
  before_filter :initialize_media_element_with_owner, :only => :destroy
  before_filter :initialize_media_element_with_owner_and_private, :only => :update
  before_filter :initialize_layout, :initialize_paginator, :only => :index
  before_filter :initialize_media_element_destination, :only => [:add, :remove, :destroy]
  
  def index
    get_own_media_elements
    if @page > @pages_amount && @pages_amount != 0
      @page = @pages_amount
      get_own_media_elements
    end
    render_js_or_html_index
  end
  
  def new
    render :layout => 'media_element_editor'
  end
  
  def create
    record = MediaElement.new :media => params[:media]
    record.title = params[:title_placeholder] != '0' ? '' : params[:title]
    record.description = params[:description_placeholder] != '0' ? '' : params[:description]
    record.tags = params[:tags_value]
    record.user_id = current_user.id
    record.validating_in_form = true
    if record.save
      Notification.send_to current_user.id, t("notifications.#{record.class.to_s.downcase}.upload.started", item: record.title)
    else
      @errors = convert_media_element_uploader_messages record.errors
      fields = record.errors.messages.keys
      if fields.include? :sti_type
        fields << :media if !fields.include? :media
        fields.delete :sti_type
      end
      @error_fields = []
      fields.each do |f|
        @error_fields << f.to_s
      end
    end
    render :layout => false
  end
  
  def add
    @ok_msg = t('other_popup_messages.correct.add.media_element')
    if @ok
      if !current_user.bookmark('MediaElement', @media_element_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_media_element')
      end
    else
      @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_media_element')
    end
    if @destination == ButtonDestinations::FOUND_MEDIA_ELEMENT
      prepare_media_element_for_js
      render 'media_elements/reload.js'
    else
      render :json => {:ok => @ok, :msg => (@ok ? @ok_msg : @error)}
    end
  end
  
  def destroy
    if @ok
      if !@media_element.check_and_destroy
        @ok = false
        @error = @media_element.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.media_element.problem_destroying')
    end
    render :json => {:ok => @ok, :msg => @error}
  end
  
  def remove
    @ok_msg = t('other_popup_messages.correct.remove.media_element')
    if @ok
      bookmark = Bookmark.where(:user_id => current_user.id, :bookmarkable_type => 'MediaElement', :bookmarkable_id => @media_element_id).first
      if bookmark.nil?
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_media_element')
      else
        bookmark.destroy
        if Bookmark.where(:user_id => current_user.id, :bookmarkable_type => 'MediaElement', :bookmarkable_id => @media_element_id).any?
          @ok = false
          @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_media_element')
        end
      end
    else
      @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_media_element')
    end
    if @destination == ButtonDestinations::FOUND_MEDIA_ELEMENT
      prepare_media_element_for_js
      render 'media_elements/reload.js'
    else
      render :json => {:ok => @ok, :msg => (@ok ? @ok_msg : @error)}
    end
  end
  
  def update
    if @ok
      @media_element.title = params[:title]
      @media_element.description = params[:description]
      @media_element.tags = params[:tags_value]
      @media_element.validating_in_form = true
      if !@media_element.save
        @errors = convert_item_error_messages @media_element.errors.messages
        @error_fields = @media_element.errors.messages.keys
      else
        @media_element.set_status current_user.id
      end
    end
  end
  
  def load_preview
    @media_element_id = correct_integer?(params[:media_element_id]) ? params[:media_element_id].to_i : 0
    @media_element = MediaElement.find_by_id @media_element_id
    if !@media_element.nil? && (@media_element.is_public || @media_element.user_id == current_user.id) && @media_element.converted
      @ok = true
      @media_element.set_status current_user.id
    else
      @ok = false
    end
  end
  
  private
  
  def get_own_media_elements
    current_user_own_media_elements = current_user.own_media_elements(@page, @for_page, @filter)
    @media_elements = current_user_own_media_elements[:records]
    @pages_amount = current_user_own_media_elements[:pages_amount]
  end
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @display = [MediaElement::DISPLAY_MODES[:compact], MediaElement::DISPLAY_MODES[:expanded]].include?(params[:display]) ? params[:display] : MediaElement::DISPLAY_MODES[:expanded]
    @for_page_options = @display == MediaElement::DISPLAY_MODES[:compact] ? FOR_PAGE_COMPACT_OPTIONS : FOR_PAGE_EXPANDED_OPTIONS
    @for_page = (@display == MediaElement::DISPLAY_MODES[:expanded]) ? FOR_PAGE_EXPANDED : FOR_PAGE_COMPACT
    if correct_integer?(params[:for_page])
      @for_page = 
        if @display == MediaElement::DISPLAY_MODES[:expanded]
          FOR_PAGE_EXPANDED_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page
        else
          FOR_PAGE_COMPACT_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page
        end
    end
    @filter = params[:filter]
    @filter = Filters::ALL_MEDIA_ELEMENTS if !Filters::MEDIA_ELEMENTS_SET.include?(@filter)
  end
  
end
