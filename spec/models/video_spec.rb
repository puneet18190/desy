require 'spec_helper'
describe Video, slow: true do

  supported_formats = [:webm, :mp4]

  let(:uploaded_path) { "#{MEVSS::SAMPLES_FOLDER}/in put.flv" }
  let(:filename)      { File.basename(uploaded_path) }
  let(:tempfile)      { File.open(uploaded_path) }
  let(:uploaded)      { ActionDispatch::Http::UploadedFile.new(filename: filename, tempfile: tempfile) }
  let(:output_folder) { "#{Rails.root}/public/media_elements/videos/#{Rails.env}/#{model.id}" }

  describe '#save' do
    context 'with a not converted valid video' do
      
      subject { described_class.new(media: uploaded) }

      let(:output_format) { "#{Rails.root}/public/media_elements/videos/#{Rails.env}/#{subject.id}/in-put.%s" }

      before(:all) do
        FileUtils.cp MEVSS::VALID_VIDEO, uploaded_path
        subject.save
      end

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
  end

  describe '#destroy' do

    subject { described_class.new(media: uploaded) }
    let(:model) { subject }

    context 'with a converted valid video' do

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


end