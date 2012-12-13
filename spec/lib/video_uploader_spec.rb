require 'spec_helper'

shared_examples 'after saving a video with a valid media' do
  let(:public_relative_folder) { "/media_elements/videos/test/#{video.id}" }
  let(:absolute_folder)        { "#{Rails.root}/public#{public_relative_folder}" }
  let(:name)                   { 'tmp-valid-video' }
  let(:path_without_extension) { "#{public_relative_folder}/#{name}" }
  let(:paths)                  { { mp4: "#{path_without_extension}.mp4", webm: "#{path_without_extension}.webm",
                                   cover: "#{public_relative_folder}/cover_#{name}.jpg", thumb: "#{public_relative_folder}/thumb_#{name}.jpg" } }
  let(:absolute_paths)         { { mp4: "#{absolute_folder}/#{name}.mp4", webm: "#{absolute_folder}/#{name}.webm",
                                   cover: "#{absolute_folder}/cover_#{name}.jpg", thumb: "#{absolute_folder}/thumb_#{name}.jpg" } }
  let(:durations)              { { mp4_duration: 38.19, webm_duration: 38.17 } }
  let(:info)                   { Hash[ [:mp4, :webm].map{ |f| [f, MediaEditing::Video::Info.new(video.media.absolute_path(f))] } ] }

  it 'resets model rename_media attribute' do
    video.rename_media.should_not be_true
  end

  it 'resets model skip_conversion attribute' do
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
    Hash[ [:mp4, :webm, :cover, :thumb].map{ |f| [f, video.media.path(f)] } ].should == paths
  end

  it 'has the expected absolute_paths' do
    Hash[ [:mp4, :webm, :cover, :thumb].map{ |f| [f, video.media.absolute_path(f)] } ].should == absolute_paths
  end

  it 'creates valid videos' do
    expect{ [:mp4, :webm].map{ |f| MediaEditing::Video::Info.new(video.media.absolute_path(f)) } }.to_not raise_error
  end

  it 'creates the video cover' do
    File.exists?(video.media.absolute_path(:cover)).should be_true
  end

  it 'creates the video thumb' do
    File.exists?(video.media.absolute_path(:thumb)).should be_true
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

      include_examples 'after saving a video with a valid media'
    end

    context 'with a ActionDispatch::Http::UploadedFile', slow: true do
      let(:media) { ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_video_path), tempfile: File.open(tmp_valid_video_path)) }
      let(:video) { Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) { |v| v.user_id = User.admin.id } }

      before(:all) do
        video.save!
        video.reload
      end

      include_examples 'after saving a video with a valid media'
    end

    context 'with a Hash', focus: true do
      let(:media_without_extension) { media_folder.join('con verted').to_s }
      let(:media)                   { { filename: 'tmp.valid video', mp4: "#{media_without_extension}.mp4", webm: "#{media_without_extension}.webm" } }
      let(:video)                   { Video.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) { |v| v.user_id = User.admin.id } }

      before(:all) { video.save! }

      include_examples 'after saving a video with a valid media'
    end
  end

  after(:all) do
    FileUtils.rm tmp_valid_video_path if File.exists? tmp_valid_video_path
  end
end
