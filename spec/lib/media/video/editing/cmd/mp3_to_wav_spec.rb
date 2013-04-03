require 'spec_helper'

module Media
  module Video
    module Editing
      class Cmd
        describe M4aToWav do
          subject { described_class.new('inp ut', 'out put') }
          
          its(:to_s) { should == %Q[lame --verbose inp\\ ut --decode out\\ put] }
        end
      end
    end
  end
end
