class LessonEditorController < ApplicationController
  
  before_filter :check_available_for_user
  before_filter :initialize_lesson_with_owner, :only => [:index, :update, :edit]
  before_filter :initialize_subjects, :only => [:new, :edit]
  before_filter :initialize_lesson_with_owner_and_slide, :only => [:add_slide, :save_slide, :delete_slide, :change_slide_position]
  before_filter :initialize_kind, :only => :add_slide
  before_filter :initialize_position, :only => :change_slide_position
  before_filter :reset_players_counter, :only => :index
  layout 'lesson_editor'
  
  def index
    if !@ok
      redirect_to '/dashboard'
      return
    else
      @slides = @lesson.slides.order(:position)
    end
  end
  
  def new
  end
  
  def create
    # TODO controllare redirect
    new_lesson = current_user.create_lesson params[:title], params[:description], params[:subject], params[:tags]
    if new_lesson.instance_of?(Lesson)
      @lesson = new_lesson
    else
      @errors = new_lesson
    end
  end
  
  def update
    if !@ok
      redirect_to '/dashboard'
      return
    else
      @lesson.title = params[:lesson][:title]
      @lesson.description =  params[:lesson][:description]
      @lesson.subject_id = params[:subject]
      @lesson.tags = params[:lesson][:tags]
      @lesson.modified
      if !@lesson.save
        @errors = @lesson.errors.messages
      end
    end
  end
  
  def edit
    if !@ok
      redirect_to '/dashboard'
      return
    end
  end
  
  def add_slide
    if @ok
      @current_slide = @lesson.add_slide @kind, (@slide.position + 1)
      @slides = @lesson.slides.order(:position)
    end
  end
  
  def save_slide
    save_current_slide if @ok
  end
  
  def delete_slide
    if @ok
      @current_slide = @lesson.slides.where(:position => @slide.position - 1).first
      @slide.destroy_with_positions
      @slides = @lesson.slides.order(:position)
    end
  end
  
  def change_slide_position
    if @ok
      @replaced_slide = Slide.find_by_lesson_id_and_position(@lesson_id, @position)
      @slide.change_position(@position)
      @slides = @lesson.slides.order(:position)
      @current_slide = @slide
    end
  end
  
  def get_tag_list
    if params[:term]
      @tags = Tag.where("word ILIKE '%#{params[:term]}%'").select("id, word AS value").limit(20)
    else
      @tags = Tag.select("id, word AS value").limit(20)
    end
    
    if @tags.count == 0
      @tags = [:id=>0,:value=>params[:term]]
    end
    logger.info "\n\n\n\n\n #{@tags.to_json} \n\n\n\n\n"
    render :json => @tags
  end
  
  private
  
  def check_available_for_user
    l = Lesson.find_by_id params[:lesson_id]
    if l && !l.available?
      render 'not_available'
      return
    end
  end
  
  def initialize_kind
    @kind = Slide::KINDS_WITHOUT_COVER.include?(params[:kind]) ? params[:kind] : ''
    update_ok(!@kind.blank?)
  end
  
  def initialize_lesson_with_owner_and_slide
    initialize_lesson_with_owner
    @slide_id = correct_integer?(params[:slide_id]) ? params[:slide_id].to_i : 0
    @slide = Slide.find_by_id @slide_id
    update_ok(@slide && @lesson && @lesson.id == @slide.lesson_id)
  end
  
  def initialize_subjects
    @subjects = []
    UsersSubject.joins(:subject).where(:user_id => current_user.id).order('subjects.description ASC').each do |sbj|
      @subjects << sbj.subject
    end
    @subjects
  end
  
  def save_current_slide
    media_elements_params = {}
    (1...5).each do |i|
      if !params["media_element_#{i}"].blank?
        media_element_id = correct_integer?(params["media_element_#{i}"]) ? params["media_element_#{i}"].to_i : 0
        alignment = params["media_element_align_#{i}"].blank? ? nil : params["media_element_align_#{i}"].to_i
        caption = params["caption_#{i}"]
        media_elements_params[i] = [media_element_id, alignment, caption]
      end
    end
    @ok = @slide.update_with_media_elements((params[:title].blank? ? nil : params[:title]), (params[:text].blank? ? nil : params[:text]), media_elements_params)
  end
  
end
