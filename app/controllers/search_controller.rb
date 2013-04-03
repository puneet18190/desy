class SearchController < ApplicationController
  
  LESSONS_FOR_PAGE = SETTINGS['compact_lesson_pagination']
  MEDIA_ELEMENTS_FOR_PAGE = SETTINGS['compact_media_element_pagination']
  
  before_filter :initialize_layout, :initialize_paginator_and_filters
  
  def index
    if @did_you_search
      case @search_item
        when 'lessons'
          if @specific_tag.nil?
            get_result_lessons
            if @page > @pages_amount && @pages_amount != 0
              @page = @pages_amount
              get_result_lessons
            end
          else
            get_result_lessons_by_specific_tag
            if @page > @pages_amount && @pages_amount != 0
              @page = @pages_amount
              get_result_lessons_by_specific_tag
            end
            if @pages_amount == 0
              @specific_tag = nil
              get_result_lessons
              if @page > @pages_amount && @pages_amount != 0
                @page = @pages_amount
                get_result_lessons
              end
            else
              @tags = current_user.search_lessons(@word, 1, @for_page, SearchOrders::TITLE, @filter, @subject_id, true)
            end
          end
        when 'media_elements'
          if @specific_tag.nil?
            get_result_media_elements
            if @page > @pages_amount && @pages_amount != 0
              @page = @pages_amount
              get_result_media_elements
            end
          else
            get_result_media_elements_by_specific_tag
            if @page > @pages_amount && @pages_amount != 0
              @page = @pages_amount
              get_result_media_elements_by_specific_tag
            end
            if @pages_amount == 0
              @specific_tag = nil
              get_result_media_elements
              if @page > @pages_amount && @pages_amount != 0
                @page = @pages_amount
                get_result_media_elements
              end
            else
              @tags = current_user.search_media_elements(@word, 1, @for_page, SearchOrders::TITLE, @filter, true)
            end
          end
      end
    end
    @subjects = Subject.order(:description)
    render_js_or_html_index
  end
  
  private
  
  def get_result_media_elements_by_specific_tag # :doc:
    resp = current_user.search_media_elements(@specific_tag_id, @page, @for_page, @order, @filter)
    @media_elements = resp[:records]
    @pages_amount = resp[:pages_amount]
    @media_elements_amount = resp[:records_amount]
  end
  
  def get_result_lessons_by_specific_tag # :doc:
    resp = current_user.search_lessons(@specific_tag_id, @page, @for_page, @order, @filter, @subject_id)
    @lessons = resp[:records]
    @pages_amount = resp[:pages_amount]
    @lessons_amount = resp[:records_amount]
  end
  
  def get_result_media_elements # :doc:
    resp = current_user.search_media_elements(@word, @page, @for_page, @order, @filter)
    @media_elements = resp[:records]
    @pages_amount = resp[:pages_amount]
    @media_elements_amount = resp[:records_amount]
    @tags = []
    @tags = resp[:tags] if resp.has_key? :tags
  end
  
  def get_result_lessons # :doc:
    resp = current_user.search_lessons(@word, @page, @for_page, @order, @filter, @subject_id)
    @lessons = resp[:records]
    @pages_amount = resp[:pages_amount]
    @lessons_amount = resp[:records_amount]
    @tags = []
    @tags = resp[:tags] if resp.has_key? :tags
  end
  
  def initialize_paginator_and_filters # :doc:
    @did_you_search = params.has_key? :word
    @search_item = ['lessons', 'media_elements'].include?(params[:item]) ? params[:item] : 'lessons'
    if @did_you_search
      initialize_word_and_specific_tag
      case @search_item
        when 'lessons'
          initialize_paginator_and_filters_for_lessons
        when 'media_elements'
          initialize_paginator_and_filters_for_media_elements
      end
    end
  end
  
  def initialize_paginator_and_filters_for_media_elements # :doc:
    @filter = Filters::MEDIA_ELEMENTS_SEARCH_SET.include?(params[:filter]) ? params[:filter] : Filters::ALL_MEDIA_ELEMENTS
    @order = SearchOrders::MEDIA_ELEMENTS_SET.include?(params[:order]) ? params[:order] : SearchOrders::UPDATED_AT
    @for_page = MEDIA_ELEMENTS_FOR_PAGE
  end
  
  def initialize_paginator_and_filters_for_lessons # :doc:
    @filter = Filters::LESSONS_SEARCH_SET.include?(params[:filter]) ? params[:filter] : Filters::ALL_LESSONS
    @order = SearchOrders::LESSONS_SET.include?(params[:order]) ? params[:order] : SearchOrders::UPDATED_AT
    @subject_id = correct_integer?(params[:subject_id]) ? params[:subject_id].to_i : nil
    @for_page = LESSONS_FOR_PAGE
  end
  
  def initialize_word_and_specific_tag # :doc:
    @word = params[:word_placeholder].blank? ? '' : params[:word]
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @specific_tag_id = correct_integer?(params[:tag_id]) ? params[:tag_id].to_i : nil
    @specific_tag = Tag.find_by_id @specific_tag_id
    @word = @specific_tag.word if !@specific_tag.nil? && (@word.blank? || (/#{@word}/ =~ @specific_tag.word) != 0)
  end
  
end
