require 'spec_helper'
describe Video, slow: true do

  supported_formats = [:webm, :mp4]

  let(:location)      { Location.create!(   description: ::CONFIG['locations'].first    ) }
  let(:school_level)  { SchoolLevel.create!(description: ::CONFIG['school_levels'].first) }
  let(:db_subject)    { Subject.create!(    description: ::CONFIG['subjects'].first     ) }
  let!(:user)         do
    User.admin || (
      user_name    = ::CONFIG['admin_username'].split(' ').first
      user_surname = ::CONFIG['admin_username'].gsub("#{user_name} ", '')
      unless user = User.create_user(::CONFIG['admin_email'], user_name, user_surname, 'School', school_level.id, location.id, [db_subject.id])
        raise 'could not create admin user'
      end
      user
    )
  end
  let(:uploaded_path) { "#{MEVSS::SAMPLES_FOLDER}/in put.flv" }
  let(:filename)      { File.basename(uploaded_path) }
  let(:tempfile)      { File.open(uploaded_path) }
  let(:uploaded)      { ActionDispatch::Http::UploadedFile.new(filename: filename, tempfile: tempfile) }
  let(:output_folder) { "#{Rails.root}/public/media_elements/videos/#{Rails.env}/#{model.id}" }

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

    let(:output_format) { "#{Rails.root}/public/media_elements/videos/#{Rails.env}/#{subject.id}/in-put.%s" }

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