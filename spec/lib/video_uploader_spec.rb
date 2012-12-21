require 'spec_helper'

describe VideoUploader do

  let(:media_folder)         { Rails.root.join('spec/support/samples') }
  let(:valid_video_path)     { media_folder.join 'valid video.flv' }
  let(:tmp_valid_video_path) { media_folder.join 'tmp.valid video.flv' }

  before(:all) do
    ['public/media_elements/videos/test', 'tmp/media_editing/video/conversions/test'].each do |folder|
      f = Rails.root.join(folder)
      FileUtils.rm_rf f if Dir.exists? f
    end
  end

  before do
    FileUtils.cp valid_video_path, tmp_valid_video_path
  end

  context 'with a new record' do
    context 'with a File', slow: true do
      it 'works' do
        media = File.open(tmp_valid_video_path)
        video = Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |v|
          v.user_id = User.admin.id
        end
        expect{ video.save! }.to_not raise_error
        video.reload
        video.metadata.marshal_dump.should == { mp4_duration: 38.19, webm_duration: 38.17 }
        video[:media].should == 'tmp-valid-video'
        video.media.to_s.should == "/media_elements/videos/test/#{video.id}/tmp-valid-video" 
        public_relative_folder = "/media_elements/videos/test/#{video.id}"
        video.media.paths.should == { mp4: "#{public_relative_folder}/tmp-valid-video.mp4", webm: "#{public_relative_folder}/tmp-valid-video.webm" }
      end
    end
    context 'with a ActionDispatch::Http::UploadedFile', slow: true do
      it 'works' do
        uploaded_path = tmp_valid_video_path
        filename      = File.basename(uploaded_path)
        tempfile      = File.open(uploaded_path)
        media         = ActionDispatch::Http::UploadedFile.new(filename: filename, tempfile: tempfile)
        video = Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |v|
          v.user_id = User.admin.id
        end
        expect{ video.save! }.to_not raise_error
        video.reload
        video.metadata.marshal_dump.should == { mp4_duration: 38.19, webm_duration: 38.17 }
        video[:media].should == 'tmp-valid-video'
        video.media.to_s.should == "/media_elements/videos/test/#{video.id}/tmp-valid-video" 
        public_relative_folder = "/media_elements/videos/test/#{video.id}"
        video.media.paths.should == { mp4: "#{public_relative_folder}/tmp-valid-video.mp4", webm: "#{public_relative_folder}/tmp-valid-video.webm" }
      end
    end
    context 'with a Hash' do
      focus 'works' do
        media_without_extension = media_folder.join('con verted').to_s
        media = { filename: 'tmp.valid video', mp4: "#{media_without_extension}.mp4", webm: "#{media_without_extension}.webm" }
        video = Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |v|
          v.user_id = User.admin.id
        end
        expect{ video.save! }.to_not raise_error
        video.rename_media.should_not be_true
        video.skip_conversion.should_not be_true
        video.metadata.marshal_dump.should == { mp4_duration: 38.19, webm_duration: 38.17 }
        video[:media].should == 'tmp-valid-video'
        video.media.to_s.should == "/media_elements/videos/test/#{video.id}/tmp-valid-video" 
        public_relative_folder = "/media_elements/videos/test/#{video.id}"
        video.media.paths.should == { mp4: "#{public_relative_folder}/tmp-valid-video.mp4", webm: "#{public_relative_folder}/tmp-valid-video.webm" }
      end
    end
  end

  after do
    FileUtils.rm tmp_valid_video_path if File.exists? tmp_valid_video_path
  end
end