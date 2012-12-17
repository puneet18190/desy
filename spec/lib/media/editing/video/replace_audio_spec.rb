require 'spec_helper'

module MediaEditing
  module Video
    describe ReplaceAudio do

      describe '.new' do
        subject { described_class.new(video_inputs, audio_inputs, output_without_extension) }

        let(:valid_video_inputs) { { mp4: 'input', webm: 'input' } }
        let(:valid_audio_inputs) { { mp3: 'input', ogg:  'input' } }

        let(:output_without_extension) { 'output' }

        context 'when inputs are not an Hash' do
          let(:video_inputs) { nil }
          let(:audio_inputs) { nil }
          it { expect { subject }.to raise_error Error }
        end

        context 'when video_inputs is not an Hash' do
          let(:video_inputs) { nil }
          let(:audio_inputs) { valid_audio_inputs }
          it { expect { subject }.to raise_error Error }
        end

        context 'when audio_inputs is not an Hash' do
          let(:video_inputs) { valid_video_inputs }
          let(:audio_inputs) { nil }
          it { expect { subject }.to raise_error Error }
        end

        context 'when inputs have not the right keys' do
          let(:video_inputs) { { ciao: 'input' } }
          let(:audio_inputs) { { ola:  'input' } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when video inputs have not the right keys' do
          let(:video_inputs) { { ciao: 'input' } }
          let(:audio_inputs) { valid_audio_inputs }
          it { expect { subject }.to raise_error Error }
        end

        context 'when audio inputs have not the right keys' do
          let(:video_inputs) { valid_video_inputs }
          let(:audio_inputs) { { ola:  'input' } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when inputs are not Strings' do
          let(:video_inputs) { { mp4: nil, webm: nil } }
          let(:audio_inputs) { { mp3: nil, ogg:  nil } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when video inputs are not Strings' do
          let(:video_inputs) { { mp4: nil, webm: nil } }
          let(:audio_inputs) { valid_audio_inputs }
          it { expect { subject }.to raise_error Error }
        end

        context 'when audio inputs are not Strings' do
          let(:video_inputs) { valid_video_inputs }
          let(:audio_inputs) { { mp3: nil, ogg:  nil } }
          it { expect { subject }.to raise_error Error }
        end

        context 'when output_without_extension is not a String' do
          let(:video_inputs) { valid_video_inputs }
          let(:audio_inputs) { valid_audio_inputs }

          let(:output_without_extension) { nil }
          it { expect { subject }.to raise_error Error }
        end

        context 'when inputs have the right keys and the right values' do
          let(:video_inputs) { valid_video_inputs }
          let(:audio_inputs) { valid_audio_inputs }
          it { expect { subject }.to_not raise_error }
        end


      end

      describe '#run' do

        def tmp_dir
          @tmp_dir ||= Dir.mktmpdir
        end
        let(:output) { File.join tmp_dir, 'out put' }

        MESS::REPLACE_AUDIO_VIDEOS.each do |description, other_infos|
          video_inputs, audio_inputs = other_infos[:video_inputs], other_infos[:audio_inputs]

          context "with #{description.to_s.gsub('_',' ')}" do

            let(:video_inputs)  { video_inputs }
            let(:audio_inputs)  { audio_inputs }
            let(:replace_audio) { described_class.new(video_inputs, audio_inputs, output) }

            subject { replace_audio.run }

            before(:all) { subject }

            it 'has the expected log folder' do
              replace_audio.send(:log_folder).should start_with Rails.root.join('log/media/video/editing/replace_audio/test/').to_s
            end

            MESS::FORMATS.each do |format|

              context "with #{format} format", format: format do

                let(:format)      { format }
                let(:description) { description }
                let(:input_info)  { Info.new(video_inputs[format]).info }
                let(:output_info) { Info.new(subject[format]).info }

                it 'creates a video with the expected duration' do
                  output_info[:duration].should be_within(0.1).of input_info[:duration]
                end
              end

            end

          end
        end

        # after { Dir.glob("#{@tmp_dir}/*") { |file| FileUtils.rm file } if @tmp_dir }

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