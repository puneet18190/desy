class Admin::LessonsController < ApplicationController
  before_filter :find_lesson, :only => [:destroy]
  layout 'admin'
  def index
    #@lessons = Lesson.order('id DESC').page params[:page] #to manage others search
    #@lessons = Lesson.joins(:user,:subject,:likes).select('lessons.*, users.name, subjects.description, count(likes) AS likes_count').group('lessons.id').sorted(params[:sort], "lessons.id DESC").page(params[:page])
    @total_lessons = Lesson.joins(:user,:subject).sorted(params[:sort], "lessons.id DESC")
    @lessons = @total_lessons.page(params[:page])
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @lessons }
    end
  end

  def destroy
    @lesson.destroy

    respond_to do |wants|
      wants.html { redirect_to(lessons_url) }
      wants.xml  { head :ok }
    end
  end

  private
    def find_lesson
      @lesson = Lesson.find(params[:id])
    end

end
