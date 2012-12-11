require 'spec_helper'

module MediaEditing
  module Video
    class Cmd
      module Concat
        describe Mp4 do
          let(:pre_command) { MEVSS::AVCONV_PRE_COMMAND }
          
          subject { described_class.new('video input', audio_input, 10, 'out put') }
          
          context 'with audio input' do
            let(:audio_input) { 'audio input' }
            its(:to_s) { should == %Q[#{pre_command} -i video\\ input -i audio\\ input -sn -threads #{MediaEditing::Video::AVCONV_OUTPUT_THREADS[:mp4]} -q:v 1 -q:a 4 -c:v libx264 -c:a libmp3lame -t 10.0 -shortest out\\ put] }
          end

          context 'with no audio input' do
            let(:audio_input) { nil }
            its(:to_s) { should == %Q[#{pre_command} -i video\\ input -sn -threads #{MediaEditing::Video::AVCONV_OUTPUT_THREADS[:mp4]} -q:v 1 -q:a 4 -c:v libx264 -t 10.0 -shortest out\\ put] }
          end

        end
      end
    end
  end
end