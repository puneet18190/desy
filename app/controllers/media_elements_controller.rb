class MediaElementsController < ApplicationController
  
  FOR_PAGE_COMPACT = CONFIG['compact_media_element_pagination']
  FOR_PAGE_COMPACT_OPTIONS = CONFIG['compact_media_element_pagination_options']
  FOR_PAGE_EXPANDED = CONFIG['expanded_media_element_pagination']
  FOR_PAGE_EXPANDED_OPTIONS = CONFIG['expanded_media_element_pagination_options']
  
  def index
    initialize_paginator
    @media_elements = @current_user.own_media_elements(@page, @for_page)
    @media_elements.each do |me|
      me.set_status @current_user.id
    end
  end
  
  private
  
  def initialize_paginator
    @page = (params[:page].blank? || params[:page].to_i <= 0) ? 1 : params[:page].to_i
    @format = (params[:format].blank || ![Formats::COMPACT, Formats::EXPANDED].include?(params[:format])) ? Formats::EXPANDED : params[:format]
    @for_page = (@format == Formats::EXPANDED) ? FOR_PAGE_EXPANDED : FOR_PAGE_COMPACT
    if !params[:for_page].blank? && params[:for_page].to_i > 0
      @for_page = (@format == Formats::EXPANDED) ? (FOR_PAGE_EXPANDED_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page) : (FOR_PAGE_COMPACT_OPTIONS.include?(params[:for_page].to_i) ? params[:for_page].to_i : @for_page)
    end
  end
  
end
