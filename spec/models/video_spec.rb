require 'spec_helper'

describe Video, slow: true do

  def media_folder
    @media_folder ||= Rails.root.join('spec/support/samples')
  end

  def media_without_extension
    @media_without_extension ||= media_folder.join('con verted').to_s
  end

  def tmp_valid_video_path
    @tmp_valid_video_path ||= media_folder.join 'tmp.valid video.flv'
  end

  def media_uploaded
    @media_uploaded ||= ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_video_path), tempfile: tmp_valid_video_path.open)
  end

  def media_hash
    @media_hash ||= { filename: 'tmp.valid video', mp4: "#{media_without_extension}.mp4", webm: "#{media_without_extension}.webm" }
  end

  def subject
    @subject ||= described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_uploaded) do |video|
      video.user = User.admin
    end
  end

  def saved
    FileUtils.cp MESS::VALID_VIDEO, tmp_valid_video_path
    subject.save!
    subject
  end

  let(:valid_video_path) { media_folder.join 'valid video.flv' }
  let(:user)             { User.admin }

  describe '#save' do
    before(:all) { saved.reload }

    let(:video) { subject }
      
    include_examples 'after saving a video with a valid not converted media'
  end

  describe '#destroy' do
    def subject
      @subject ||= described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media_hash) do |video|
        video.user = User.admin
      end
    end

    before(:all) { saved.reload.destroy }

    let(:output_folder) { "#{Rails.root}/public/media_elements/videos/test/#{subject.id}" }

    it 'gets destroyed' do
      expect(described_class.find_by_id(subject.id)).to be_nil
    end

    it 'destroys the video folder' do
      expect(File.exist?(output_folder)).to be false
    end
  end

  after(:all) do
    FileUtils.rm tmp_valid_video_path if File.exists? tmp_valid_video_path
  end

end