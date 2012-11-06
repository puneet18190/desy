class MediaElementsController < ApplicationController
  
  FOR_PAGE_COMPACT = CONFIG['compact_media_element_pagination']
  FOR_PAGE_COMPACT_OPTIONS = CONFIG['compact_media_element_pagination_options']
  FOR_PAGE_EXPANDED = CONFIG['expanded_media_element_pagination']
  FOR_PAGE_EXPANDED_OPTIONS = CONFIG['expanded_media_element_pagination_options']
  
  before_filter :initialize_media_element, :only => [:add, :remove]
  before_filter :initialize_media_element_with_owner, :only => :destroy
  before_filter :initialize_layout, :initialize_paginator, :only => :index
  
  def index
    get_own_media_elements
    if @last_page && (@page != 1) && @media_elements.empty?
      @page = @tot_items / @for_page
      get_own_media_elements
    end
    render_js_or_html_index
  end
  
  def add
    if @ok
      if !@current_user.bookmark('MediaElement', @media_element_id)
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
      render :nothing => true
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
    render :nothing => true
  end
  
  def remove
    if @ok
      bookmark = Bookmark.where(:user_id => @current_user.id, :bookmarkable_type => 'MediaElement', :bookmarkable_id => @media_element_id).first
      if bookmark.nil?
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_media_element')
      else
        bookmark.destroy
        if Bookmark.where(:user_id => @current_user.id, :bookmarkable_type => 'MediaElement', :bookmarkable_id => @media_element_id).any?
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
      render :nothing => true
    end
  end
  
  def change_info
    
  end
  
  private
  
  def get_own_media_elements
    resp = @current_user.own_media_elements(@page, @for_page, @filter)
    @media_elements = resp[:content]
    @last_page = resp[:last_page]
    @tot_items = resp[:count]
  end
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @display = (params[:display].blank? || ![Formats::COMPACT, Formats::EXPANDED].include?(params[:display])) ? Formats::EXPANDED : params[:display]
    @for_page_options = @display == Formats::COMPACT ? FOR_PAGE_COMPACT_OPTIONS : FOR_PAGE_EXPANDED_OPTIONS
    @for_page = (@display == Formats::EXPANDED) ? FOR_PAGE_EXPANDED : FOR_PAGE_COMPACT
    if correct_integer?(params[:for_page])
      @for_page = (@display == Formats::EXPANDED) ? (FOR_PAGE_EXPANDED_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page) : (FOR_PAGE_COMPACT_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page)
    end
    @filter = params[:filter]
    @filter = Filters::ALL_MEDIA_ELEMENTS if !Filters::MEDIA_ELEMENTS_SET.include?(@filter)
  end
  
end
