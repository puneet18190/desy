require 'spec_helper'

module MediaEditing
  module Video
    class Cmd
      describe GenerateTransitionFrames do

        let(:pre_command) { MESS::IMAGEMAGICK_CONVERT_PRE_COMMAND }
        
        subject { described_class.new('start frame', 'end frame', 'frames format', 23) }
        
        let(:command) { "#{pre_command} start\\ frame end\\ frame -morph 23 frames\\ format" }

        its(:to_s) { should == command }

      end
    end
  end
end
