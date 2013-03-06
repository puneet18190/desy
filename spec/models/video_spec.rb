require 'spec_helper'

describe Video, slow: true do

  let(:media_folder)            { Rails.root.join('spec/support/samples') }
  let(:media_without_extension) { media_folder.join('con verted').to_s }
  let(:valid_video_path)        { media_folder.join 'valid video.flv' }
  let(:tmp_valid_video_path)    { media_folder.join 'tmp.valid video.flv' }
  let(:media_uploaded)          { ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_video_path), tempfile: tmp_valid_video_path.open) }
  let(:media_hash)              { { filename: 'tmp.valid video', mp4: "#{media_without_extension}.mp4", webm: "#{media_without_extension}.webm" } }
  let(:user)                    { User.admin }

  def saved
    FileUtils.cp MESS::VALID_VIDEO, tmp_valid_video_path
    subject.save!
    subject
  end

  subject do
    described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_uploaded) do |video|
      video.user = User.admin
    end
  end

  describe '#save' do
    before(:all) { saved.reload }

    let(:video) { subject }
      
    include_examples 'after saving a video with a valid not converted media'
  end

  describe '#destroy' do
    subject do
      described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash) do |video|
        video.user = User.admin
      end
    end

    before(:all) { saved.reload.destroy }

    let(:output_folder) { "#{Rails.root}/public/media_elements/videos/test/#{subject.id}" }

    it 'should be destroyed' do
      described_class.find_by_id(subject.id).should be_nil
    end

    it 'destroys the video folder' do
      File.exists?(output_folder).should_not be_true
    end
  end

  after(:all) do
    FileUtils.rm tmp_valid_video_path if File.exists? tmp_valid_video_path
  end

end