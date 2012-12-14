require 'spec_helper'

describe Video, slow: true do

  let(:media_folder)         { Rails.root.join('spec/support/samples') }
  let(:valid_video_path)     { media_folder.join 'valid video.flv' }
  let(:tmp_valid_video_path) { media_folder.join 'tmp.valid video.flv' }
  let(:media)                { ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_video_path), tempfile: File.open(tmp_valid_video_path)) }
  let(:user)                 { User.admin }

  def saved
    FileUtils.cp MESS::VALID_VIDEO, tmp_valid_video_path
    subject.save!
    subject
  end

  subject do
    described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |video|
      video.user = User.admin
    end
  end

  describe '#save' do

    before(:all) { saved.reload }

    let(:video) { subject }
      
    include_examples 'after saving a video with a valid not converted media'

  end

  describe '#destroy' do

    before(:all) { saved.destroy }

    let(:output_folder) { "#{Rails.root}/public/media_elements/videos/test/#{subject.id}" }

    it 'destroys the video folder' do
      File.exists?(subject.media.absolute_folder).should_not be_true
    end

  end

  after(:all) do
    FileUtils.rm tmp_valid_video_path if File.exists? tmp_valid_video_path
  end

end