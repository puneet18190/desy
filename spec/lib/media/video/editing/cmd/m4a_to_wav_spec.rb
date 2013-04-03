require 'spec_helper'

module Media
  module Video
    module Editing
      class Cmd
        describe M4aToWav do
          subject { described_class.new('inp ut', 'out put') }
          
          its(:to_s) { should == %Q[avconv -loglevel debug -benchmark -y -timelimit 86400 -i inp\\ ut -threads auto -c:a pcm_s16le -map 0:a:0 out\\ put] }
        end
      end
    end
  end
end
