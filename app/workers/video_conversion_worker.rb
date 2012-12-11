require 'media_editing/video'

class VideoConversionWorker
  # include Sidekiq::Worker
  # sidekiq_options :retry => false

  # def perform(model_id, filename, uploaded_path)
  #   tempfile    = File.open(uploaded_path)
  #   uploaded    = ActionDispatch::Http::UploadedFile.new(filename: filename, tempfile: tempfile)
  #   model       = Video.find(model_id)
  #   model.media = uploaded

  #   MediaEditing::Video::Conversion.new(model).run
  # end  
  
end