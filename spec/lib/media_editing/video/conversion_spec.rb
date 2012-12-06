require 'spec_helper'
require 'shellwords'

module MediaEditing
  module Video
    describe Conversion, slow: true do

      supported_formats = MEVSS::FORMATS

      let(:uploaded_path) { "#{MEVSS::SAMPLES_FOLDER}/tmp.in put.flv" }
      let(:filename)      { 'in put.flv' }
      let(:tempfile)      { File.open(uploaded_path) }
      let(:uploaded)      { ActionDispatch::Http::UploadedFile.new(filename: filename, tempfile: tempfile) }
      let(:model)         do
        described_class.new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: uploaded) do |video|
          video.user_id = User.admin.id
        end.tap{ |v| v.skip_conversion = true; v.save!; v.media = uploaded }
      end
      let(:input)         { "#{Rails.root}/tmp/video_editing/conversions/#{Rails.env}/#{model.id}/#{filename}" }
      let(:output_folder) { "#{Rails.root}/public/media_elements/videos/#{Rails.env}/#{model.id}" }
      let(:output_format) { "#{output_folder}/in-put.%s" }
      let(:stdout_log)    { "#{Rails.root}/log/video_editing/conversions/#{Rails.env}/#{model.id}/#{format}.stdout.log" }
      let(:stderr_log)    { "#{Rails.root}/log/video_editing/conversions/#{Rails.env}/#{model.id}/#{format}.stderr.log" }

      describe '#convert_to' do

        supported_formats.each do |format|
          context "with #{format} format", format: format do

            let(:format) { format }
            let(:output) { output_format % format }

            [ [ :valid_video,               MEVSS::VALID_VIDEO ],
              [ :valid_video_with_odd_size, MEVSS::VALID_VIDEO_WITH_ODD_SIZE ] ].each do |video_data|

              video, video_constant = video_data

              context "with a #{video.to_s.humanize.downcase}" do

                before(:all) do
                  FileUtils.cp video_constant, uploaded_path
                  [ stdout_log, stderr_log, input, output ].each { |f| FileUtils.rm(f) if File.exists?(f) }
                  MediaEditing::Video::Conversion.new(model.id, filename, uploaded_path).convert_to(format)
                end

                it "creates a valid video" do
                  expect{ MediaEditing::Video::Info.new(output) }.to_not raise_error
                end

                it 'creates a video with a correct duration' do
                  input_duration, output_duration = MediaEditing::Video::Info.new(input).duration, MediaEditing::Video::Info.new(output).duration
                  input_duration.should be_within(described_class::DURATION_THRESHOLD).of(output_duration)
                end

                it "creates the stdout log" do
                  File.exists?(stdout_log).should be_true
                end

                it "creates the stderr log" do
                  File.exists?(stderr_log).should be_true
                end

                it "does not delete the input video" do
                  File.exists?(input).should be_true
                end
              
              end

            end

            context 'with an invalid video' do

              subject { MediaEditing::Video::Conversion.new(model.id, filename, uploaded_path) }
              
              before do
                FileUtils.cp MEVSS::INVALID_VIDEO, uploaded_path
                FileUtils.rm(input) if File.exists?(input)
              end

              it { expect { subject.convert_to(format) }.to raise_error(MediaEditing::Video::Error) }

            end

            context 'when upload file and input file do not exist' do

              let(:model) { ::Video.new.tap{ |v| v.skip_conversion = true; v.save } }

              subject { MediaEditing::Video::Conversion.new(model.id, filename, uploaded_path) }

              before do
                FileUtils.cp MEVSS::VALID_VIDEO, uploaded_path
                model.media = uploaded
                FileUtils.rm input if File.exists? input
                subject
                FileUtils.rm uploaded_path
              end

              it{ expect{ subject.convert_to(format) }.to raise_error(MediaEditing::Video::Error) }

            end

          end
        end

      end

      describe 'run' do

        subject { MediaEditing::Video::Conversion.new(model.id, filename, uploaded_path) }

        context 'with a valid video' do
      
          before(:all) do
            FileUtils.cp MEVSS::VALID_VIDEO, uploaded_path
            FileUtils.rm input if File.exists? input
            subject.run
            model.reload
          end

          it 'sets the model converted attribute' do
            model.should be_converted
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

              it 'sets the model duration attribute' do
                model.send(:"#{format}_duration").should == info(format).duration
              end

            end
          end

          it 'sets the model media attribute' do
            model[:media].should == 'in-put'
          end

          it 'deletes the input file' do
            File.exists?(input).should_not be_true
          end

        end
      end

    end
  end
end