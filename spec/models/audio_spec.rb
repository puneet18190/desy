require 'spec_helper'

describe Audio, slow: true do

  def media_folder
    @media_folder ||= Rails.root.join('spec/support/samples')
  end


  def tmp_valid_audio_path
    @tmp_valid_audio_path ||= media_folder.join 'tmp.valid audio.m4a'
  end

  def media
    @media ||= ActionDispatch::Http::UploadedFile.new(filename: File.basename(tmp_valid_audio_path), tempfile: File.open(tmp_valid_audio_path))
  end

  def subject
    @subject ||= described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |audio|
      audio.user = User.admin
    end
  end

  def saved
    FileUtils.cp MESS::VALID_AUDIO, tmp_valid_audio_path
    subject.save!
    subject
  end

  let(:valid_audio_path) { media_folder.join 'valid audio.m4a' }
  let(:user)             { User.admin }

  describe '#save' do
    before(:all) { saved.reload }

    let(:audio) { subject }

    include_examples 'after saving an audio with a valid not converted media'
  end

  describe '#destroy' do
    before(:all) { saved.reload.destroy }

    let(:output_folder) { "#{Rails.root}/public/media_elements/audios/test/#{subject.id}" }

    it 'gets destroyed' do
      expect(described_class.find_by_id(subject.id)).to be_nil
    end

    it 'destroys the audio folder' do
      expect(File.exist?(output_folder)).to be_false
    end
  end

  after(:all) do
    FileUtils.rm tmp_valid_audio_path if File.exists? tmp_valid_audio_path
  end

end