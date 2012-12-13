require 'spec_helper'
describe Video, slow: true do

  supported_formats = MEVSS::FORMATS

  let(:user)          { User.admin }
  let(:uploaded_path) { "#{MEVSS::SAMPLES_FOLDER}/in put.flv" }
  let(:filename)      { File.basename(uploaded_path) }
  let(:tempfile)      { File.open(uploaded_path) }
  let(:uploaded)      { ActionDispatch::Http::UploadedFile.new(filename: filename, tempfile: tempfile) }
  let(:output_folder) { "#{Rails.root}/public/media_elements/videos/test/#{model.id}" }

  subject do
    described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: uploaded) do |video|
      video.user_id = user.id
    end
  end
  
  describe '#save' do
      
    before(:all) do
      FileUtils.cp MEVSS::VALID_VIDEO, uploaded_path
      subject.save
    end

    let(:output_format) { "#{Rails.root}/public/media_elements/videos/test/#{subject.id}/in-put.%s" }

    supported_formats.each do |format|
      context "with #{format} format", format: format do
        let(:format) { format }
        def info(format)
          @info ||= {}
          @info[format] ||= MediaEditing::Video::Info.new(output_format % format)
        end

        it "creates a valid video" do
          expect{ info(format) }.to_not raise_error
        end

        it "sets the expected #{format}_duration" do
          subject.reload.send(:"#{format}_duration").should == info(format).duration
        end

      end
    end

  end

  describe '#destroy' do

    subject do
      described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: uploaded) do |video|
        video.user_id = User.admin.id
      end
    end
    let(:model) { subject }

    before(:all) do
      FileUtils.cp MEVSS::VALID_VIDEO, uploaded_path
      subject.save
      subject.destroy
    end

    it 'destroys the video folder' do
      File.exists?(output_folder).should_not be_true
    end

  end


end