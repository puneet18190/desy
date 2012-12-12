require 'spec_helper'

shared_examples 'after the saving of the associated video' do
  let(:public_relative_folder) { "/media_elements/videos/test/#{video.id}" }
  let(:name)                   { 'tmp-valid-video' }
  let(:path_without_extension) { "#{public_relative_folder}/#{name}" }
  let(:paths)                  { { mp4: "#{path_without_extension}.mp4", webm: "#{path_without_extension}.webm" } }
  let(:durations)              { { mp4_duration: 38.19, webm_duration: 38.17 } }

  it 'resets rename_media' do
    video.rename_media.should_not be_true
  end

  it 'resets skip_conversion' do
    video.skip_conversion.should_not be_true
  end

  it 'sets the expected duration' do
    video.metadata.marshal_dump.should == durations
  end

  it 'sets the expected [:media] value' do
    video[:media].should == name
  end

  it 'has the expected to_s' do
    video.media.to_s.should == path_without_extension
  end

  it 'has the expected paths' do
    video.media.paths.should == paths
  end

  it 'creates the video cover' do
    File.exists?(video.media.absolute_paths[:cover]).should be_true
  end

  it 'creates the video thumb' do
    File.exists?(video.media.absolute_paths[:thumb]).should be_true
  end
end

describe VideoUploader do
  let(:media_folder)           { Rails.root.join('spec/support/samples') }
  let(:valid_video_path)       { media_folder.join 'valid video.flv' }
  let(:tmp_valid_video_path)   { media_folder.join 'tmp.valid video.flv' }

  before(:all) do
    FileUtils.cp valid_video_path, tmp_valid_video_path
    ['public/media_elements/videos/test', 'tmp/media_editing/video/conversions/test'].each do |folder|
      f = Rails.root.join(folder)
      FileUtils.rm_rf f if Dir.exists? f
    end
  end

  context 'with a new record' do
    context 'with a File', slow: true do
      let(:media) { File.open(tmp_valid_video_path) }
      let(:video) { Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) { |v| v.user_id = User.admin.id } }
      
      before(:all) do
        video.save!
        video.reload
      end

      include_examples 'after the saving of the associated video'
    end

    context 'with a ActionDispatch::Http::UploadedFile', slow: true do
      let(:media) { ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_video_path), tempfile: File.open(tmp_valid_video_path)) }
      let(:video) { Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) { |v| v.user_id = User.admin.id } }

      before(:all) do
        video.save!
        video.reload
      end

      include_examples 'after the saving of the associated video'
    end

    context 'with a Hash' do
      let(:media_without_extension) { media_folder.join('con verted').to_s }
      let(:media)                   { { filename: 'tmp.valid video', mp4: "#{media_without_extension}.mp4", webm: "#{media_without_extension}.webm" } }
      let(:video)                   { Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) { |v| v.user_id = User.admin.id } }

      before(:all) { video.save! }

      include_examples 'after the saving of the associated video'
    end
  end

  after(:all) do
    FileUtils.rm tmp_valid_video_path if File.exists? tmp_valid_video_path
  end
end
