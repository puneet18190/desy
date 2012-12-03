class SearchController < ApplicationController
  
  LESSONS_FOR_PAGE = CONFIG['compact_lesson_pagination']
  MEDIA_ELEMENTS_FOR_PAGE = CONFIG['compact_media_element_pagination']
  
  before_filter :initialize_layout, :initialize_paginator_and_filters, :reset_players_counter
  
  def index
    if @did_you_search
      case @search_item
        when 'lessons'
          get_result_lessons
          if @page > @pages_amount && @pages_amount != 0
            @page = @pages_amount
            get_result_lessons
          end
        when 'media_elements'
          get_result_media_elements
          if @page > @pages_amount && @pages_amount != 0
            @page = @pages_amount
            get_result_media_elements
          end
      end
    end
    @tag = Tag.find_by_id(@tag) if @tag.class == Fixnum
    render_js_or_html_index
  end
  
  private
  
  def get_result_media_elements
    resp = @current_user.search_media_elements(@tag, @page, @for_page, @order, @filter)
    @media_elements = resp[:records]
    @pages_amount = resp[:pages_amount]
    @media_elements_amount = resp[:records_amount]
    @tags = []
    @tags = resp[:tags] if resp.has_key? :tags
  end
  
  def get_result_lessons
    resp = @current_user.search_lessons(@tag, @page, @for_page, @order, @filter, @subject_id)
    @lessons = resp[:records]
    @pages_amount = resp[:pages_amount]
    @lessons_amount = resp[:records_amount]
    @tags = []
    @tags = resp[:tags] if resp.has_key? :tags
  end
  
  def initialize_paginator_and_filters
    @did_you_search = params.has_key? :tag
    @search_item = ['lessons', 'media_elements'].include?(params[:item]) ? params[:item] : 'lessons'
    if @did_you_search
      @tag = params[:tag_kind].blank? ? '' : (params[:tag_kind] == '0' ? params[:tag] : (correct_integer?(params[:tag_kind]) ? params[:tag_kind].to_i : ''))
      @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
      case @search_item
        when 'lessons'
          @filter = Filters::LESSONS_SEARCH_SET.include?(params[:filter]) ? params[:filter] : Filters::ALL_LESSONS
          @order = SearchOrders::LESSONS_SET.include?(params[:order]) ? params[:order] : SearchOrders::UPDATED_AT
          @subject_id = correct_integer?(params[:subject_id]) ? params[:subject_id].to_i : nil
          @for_page = LESSONS_FOR_PAGE
        when 'media_elements'
          @filter = Filters::MEDIA_ELEMENTS_SEARCH_SET.include?(params[:filter]) ? params[:filter] : Filters::ALL_MEDIA_ELEMENTS
          @order = SearchOrders::MEDIA_ELEMENTS_SET.include?(params[:order]) ? params[:order] : SearchOrders::UPDATED_AT
          @for_page = MEDIA_ELEMENTS_FOR_PAGE
      end
    end
  end
  
end
