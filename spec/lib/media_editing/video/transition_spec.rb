require 'spec_helper'

module MediaEditing
  module Video
    describe Transition do

      describe '.new' do
        subject { described_class.new(start_inputs, end_inputs, output_without_extension) }

        let(:valid_inputs) { { mp4: 'input', webm: 'input' } }

        let(:output_without_extension) { 'output' }

        context 'when inputs are not an Hash' do
          let(:start_inputs) { nil }
          let(:end_inputs)   { nil }
          it { expect { subject }.to raise_error Error }
        end

        context 'when start_input is not an Hash' do
          let(:start_inputs) { nil }
          let(:end_inputs)   { valid_inputs }
          it { expect { subject }.to raise_error Error }
        end

        context 'when end_input is not an Hash' do
          let(:start_inputs) { valid_inputs }
          let(:end_inputs)   { nil }
          it { expect { subject }.to raise_error Error }
        end

        context 'when inputs have not the right keys' do
          let(:start_inputs) { { ciao: 'input' } }
          let(:end_inputs)   { { ola:  'input' } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when start_input have not the right keys' do
          let(:start_inputs) { { ciao: 'input' } }
          let(:end_inputs)   { valid_inputs }
          it { expect { subject }.to raise_error Error }
        end

        context 'when end_input have not the right keys' do
          let(:start_inputs) { valid_inputs }
          let(:end_inputs)   { { ola:  'input' } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when inputs are not Strings' do
          let(:start_inputs) { { mp4: nil, webm: nil } }
          let(:end_inputs)   { { mp4: nil, webm: nil } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when start_input are not Strings' do
          let(:start_inputs) { { mp4: nil, webm: nil } }
          let(:end_inputs)   { valid_inputs }
          it { expect { subject }.to raise_error Error }
        end

        context 'when end_input are not Strings' do
          let(:start_inputs) { valid_inputs }
          let(:end_inputs)   { { mp4: nil, webm: nil } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when output_without_extension is not a String' do
          let(:start_inputs) { valid_inputs }
          let(:end_inputs)   { valid_inputs }

          let(:output_without_extension) { nil }
          it { expect { subject }.to raise_error Error }
        end

        context 'when inputs have the right keys and the right values' do
          let(:start_inputs) { valid_inputs }
          let(:end_inputs)   { valid_inputs }
          it { expect { subject }.to_not raise_error }
        end

      end

      describe '#run' do

        def tmp_dir
          @tmp_dir ||= Dir.mktmpdir
        end
        let(:output) { File.join tmp_dir, 'out put' }

        context "with valid videos" do

          let(:start_inputs) { MEVSS::TRANSITION_VIDEOS[:start_inputs] }
          let(:end_inputs)   { MEVSS::TRANSITION_VIDEOS[:end_inputs] }
          let(:transition)   { described_class.new(start_inputs, end_inputs, output) }

          subject { transition.run }

          before(:all) { subject }

          it 'has the expected log folder' do
            transition.send(:log_folder).should start_with Rails.root.join('log/media_editing/video/transition/test/').to_s
          end

          MEVSS::FORMATS.each do |format|

            context "with #{format} format", format: format do

              let(:format)      { format }
              let(:output_info) { MediaEditing::Video::Info.new(subject[format]).info }

              it 'creates a video with the expected duration' do
                expected_duration = Rational(described_class::INNER_FRAMES_AMOUNT+2, described_class::FRAME_RATE)
                output_info[:duration].should == expected_duration
              end
            end

          end

        end

        after(:all) do
          if @tmp_dir 
            begin
              FileUtils.remove_entry_secure(@tmp_dir)
            ensure
              @tmp_dir = nil
            end
          end
        end

      end
    end
  end
end