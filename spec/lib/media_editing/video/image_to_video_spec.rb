require 'spec_helper'

module MediaEditing
  module Video
    describe ImageToVideo do

      supported_video_formats = MESS::FORMATS
      supported_image_formats = [:jpg, :png]

      describe '.new' do
        subject { described_class.new('input', 'output', duration) }
        context 'when duration is not a Numeric' do
          let(:duration) { nil }
          it 'raises a Error' do
            expect{ subject }.to raise_error(Error)
          end
        end
        context 'when duration is not > 0' do
          let(:duration) { 0 }
          it 'raises a Error' do
            expect{ subject }.to raise_error(Error)
          end
        end
      end

      describe '#run' do
        let(:output_prefix) { Tempfile.new(Thread.current.object_id.to_s) }
        let(:duration) { 10 }
        
        supported_image_formats.each do |image_format|
          context "with #{image_format} format", image_format: image_format do

            def log_folder_children
              Dir.glob(File.join(described_class.log_folder, '*'))
            end

            let(:image_to_video) { described_class.new(MESS.const_get(:"VALID_#{image_format.upcase}"), output_prefix.path, duration) }

            subject { image_to_video.run }

            before(:all) do
              @before_log_folder_children = log_folder_children
              subject
              @after_log_folder_children = log_folder_children
              @created_log_folders = @after_log_folder_children-@before_log_folder_children
            end

            it 'has the expected log folder' do
              image_to_video.send(:stdout_log).should start_with Rails.root.join('log/media_editing/video/image_to_video/test/').to_s
            end

            supported_video_formats.each do |format|

              def output(format)
                "#{output_prefix.path}.#{format}"
              end
              def info(format)
                @info ||= {}
                @info[format] ||= Info.new(output(format))
              end

              context "with #{format} format", format: format do
                
                it 'creates a valid video' do
                  info(format).should_not be_nil
                end
                it 'sets the correct duration' do
                  info(format).duration.should == duration
                end
                it 'sets the correct sizes' do
                  info(format).video_streams[0].select{ |k| [:width, :height].include?(k) }.should == { width: 960, height: 540 }
                end
                it "creates the log folders" do
                  @after_log_folder_children.should have(@before_log_folder_children.size+2).items
                end
                it "creates the logs" do
                  @created_log_folders.map do |log_folder|
                    Dir.glob(File.join(log_folder, '*')).map{ |log| File.basename(log) }
                  end.flatten.should include("#{format}.stderr.log")
                end
              
              end
            
            end

            after(:all) do
              output_prefix.unlink
              subject.values.each{ |output| FileUtils.rm(output) rescue nil } if subject
            end

          end
        end

      end


    end
  end
end