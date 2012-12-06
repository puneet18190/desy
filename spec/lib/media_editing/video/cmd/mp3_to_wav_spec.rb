require 'spec_helper'

module MediaEditing
  module Video
    class Cmd
      describe Mp3ToWav do
        subject { described_class.new('inp ut', 'out put') }
        
        its(:to_s) { should == %Q[lame --verbose inp\\ ut --decode out\\ put] }
      end
    end
  end
end