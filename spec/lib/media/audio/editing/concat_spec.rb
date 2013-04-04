require 'spec_helper'

module Media
  module Audio
    module Editing
      describe Concat do
  
        describe '.new' do
          let(:output_without_extension) { 'output' }
  
          subject { described_class.new(inputs, output_without_extension) }
  
          context 'when inputs is not an Array' do
            let(:inputs) { nil }
            it { expect { subject }.to raise_error Error }
          end
  
          context 'when inputs is an Hash with the wrong keys' do
            let(:inputs) { [ { ogg: 'input', ciao: 'input'} ] }
            it { expect { subject }.to raise_error Error }
          end
  
          context 'when there is some inputs value which is not an hash' do
            let(:inputs) { [ { ogg: 'input', m4a: 'input'}, nil ] }
            it { expect { subject }.to raise_error Error }
          end
  
          context 'when inputs are not paired' do
            let(:inputs) { [ { ogg: 'input', m4a: 'input'}, { ogg: 'input' } ] }
            it { expect { subject }.to raise_error Error }
          end
  
          context 'when at least one value of the inputs is empty' do
            let(:inputs) { [ { ogg: 'input', m4a: nil } ] }
            it { expect { subject }.to raise_error Error }
          end
  
          context 'when output_without_extension is not a string' do
            let(:inputs) { [ { ogg: 'input', m4a: 'input'} ] }
  
            let(:output_without_extension) { nil }
            it { expect { subject }.to raise_error Error }
          end
  
          context 'when inputs values is an Hash with the right keys and paired values' do
            context 'with one pair of values' do
              let(:inputs) { [{ ogg: 'input', m4a: 'input'} ] }
              it { expect { subject }.to_not raise_error }
            end
  
            context 'with two pairs of values' do
              let(:inputs) { [ { ogg: 'input', m4a: 'input' }, { ogg: 'input', m4a: 'input' } ] }
              it { expect { subject }.to_not raise_error }
            end
          end
  
        end
  
        describe '#run' do
  
          context 'with a single couple of input_audios' do
  
            def tmp_dir
              @tmp_dir ||= Dir.mktmpdir
            end
            let(:output)       { File.join tmp_dir, 'out put' }
            let(:input_audios) do
              MESS::CONCAT_AUDIOS[:audios][0,1]
            end
            let(:concat) { described_class.new(input_audios, output) }
            
            subject { concat.run }
  
            before(:all) { subject }
  
            it 'has the expected log folder' do
              concat.send(:stdout_log).should start_with Rails.root.join('log/media/audio/editing/concat/test/').to_s
            end
  
            MESS::AUDIO_FORMATS.each do |format|
  
              context "with #{format} format", format: format do
  
                let(:format) { format }
              
                it 'copies the inputs to the outputs' do
                  FileUtils.cmp(input_audios.first[format], subject[format]).should be_true
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
  
          context "with two couples of input audios" do

            input_audios, output_infos = MESS::CONCAT_AUDIOS[:audios], MESS::CONCAT_AUDIOS[:output_infos]
          
            def tmp_dir
              @tmp_dir ||= Dir.mktmpdir
            end
            let(:output)       { File.join tmp_dir, 'out put' }
            let(:input_audios) { input_audios }

            MESS::AUDIO_FORMATS.each do |format|
            
              context "with #{format} format", format: format do

                let(:format) { format }
                let(:info)   { Info.new(subject[format]).to_hash }
                let(:concat) { described_class.new(input_audios, output) }
                
                subject { concat.run }

                before(:all) { subject }

                it 'has the expected log folder' do
                  concat.send(:stdout_log).should start_with Rails.root.join('log/media/audio/editing/concat/test/').to_s
                end

                it 'creates a audio with the expected duration', focus: (format == :m4a) do
                  duration = info[:duration]
                  expected = output_infos[format][:duration]
                  duration.should be_within(0.2).of(expected)
                end

                it 'creates a audio with the expected amount of audio streams' do
                  audio_streams = info[:streams][:audio]
                  expected      = output_infos[format][:streams][:audio]
                  audio_streams.should have(expected.size).items
                end
                it 'creates a audio with the expected audio stream codec and sizes' do
                  codec_and_sizes = info[:streams][:audio].first.select{ |k| [:codec].include? k }
                  expected        = output_infos[format][:streams][:audio].first.select{ |k| [:codec].include? k }
                  codec_and_sizes.should == expected
                end
                it 'creates a audio with the expected audio stream bitrate' do
                  bitrate  = info[:streams][:audio].first[:bitrate]
                  expected = output_infos[format][:streams][:audio].first[:bitrate]
                  if expected
                    bitrate.should be_within(1).of(expected)
                  else
                    bitrate.should be_nil
                  end
                end

                it 'creates a audio with the expected amount of audio streams' do
                  audio_streams = info[:streams][:audio]
                  expected      = output_infos[format][:streams][:audio]
                  audio_streams.should have(expected.size).items
                end
                it 'creates a audio with the expected audio stream codec' do
                  codec    = info[:streams][:audio].first.try(:select) { |k| [:codec].include? k }
                  expected = output_infos[format][:streams][:audio].first.try(:select) { |k| [:codec].include? k }
                  codec.should == expected
                end
                it 'creates a audio with the expected audio stream bitrate' do
                  bitrate  = info[:streams][:audio].first.try(:[], :bitrate)
                  expected = output_infos[format][:streams][:audio].first.try(:[], :bitrate)
                  if expected
                    bitrate.should be_within(1).of(expected)
                  else
                    bitrate.should be_nil
                  end
                end

                after(:all) { Dir.glob("#{@tmp_dir}/*") { |file| FileUtils.rm file } if @tmp_dir }
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
    end
  end
end
