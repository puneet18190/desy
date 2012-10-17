class MediaElementsController < ApplicationController
  
  FOR_PAGE_COMPACT = CONFIG['compact_media_element_pagination']
  FOR_PAGE_COMPACT_OPTIONS = CONFIG['compact_media_element_pagination_options']
  FOR_PAGE_EXPANDED = CONFIG['expanded_media_element_pagination']
  FOR_PAGE_EXPANDED_OPTIONS = CONFIG['expanded_media_element_pagination_options']
  
  def index
    initialize_paginator
    resp = @current_user.own_media_elements(@page, @for_page, @filter)
    @media_elements = resp[:content]
    @last_page = resp[:last_page]
    if @last_page && (@page != 1) && @media_elements.empty?
      @page = 1
      resp = @current_user.own_media_elements(@page, @for_page, @filter)
      @media_elements = resp[:content]
      @last_page = resp[:last_page]
    end
    @media_elements.each do |me|
      me.set_status @current_user.id
    end
  end
  
  private
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @format = (params[:format].blank? || ![Formats::COMPACT, Formats::EXPANDED].include?(params[:format])) ? Formats::EXPANDED : params[:format]
    @for_page_options = @format == Formats::COMPACT ? FOR_PAGE_COMPACT_OPTIONS : FOR_PAGE_EXPANDED_OPTIONS
    @for_page = (@format == Formats::EXPANDED) ? FOR_PAGE_EXPANDED : FOR_PAGE_COMPACT
    if correct_integer?(params[:for_page])
      @for_page = (@format == Formats::EXPANDED) ? (FOR_PAGE_EXPANDED_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page) : (FOR_PAGE_COMPACT_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page)
    end
    @filter = params[:filter]
    @filter = Filters::ALL_MEDIA_ELEMENTS if !Filters::MEDIA_ELEMENTS_SET.include?(@filter)
  end
  
end
