class LessonDownloadController < ApplicationController
  
  layout 'lesson_download', only: :download

  def download
    # sp = Desy::Application.assets
    #
    # Forse no
    # require 'uglifier'
    # sprockets.css_compressor = YUI::CssCompressor.new
    # sprockets.js_compressor = Uglifier.new(mangle: true)
    #
    # asset = sp['application.js']
    # asset = sp['browser_not_supported/application.js']
    # asset.write_to outfile

    initialize_lesson

    @slides = @lesson.slides.order(:position)
    @cover_img = @slides.first.media_elements_slides.first
    # send_data render_to_string(action: :index, locals: {ciao: 'ciao'}), type: 'text/html; charset=utf-8', filename: 'test.html'
    
    render(action: :index)
  end
    
end
