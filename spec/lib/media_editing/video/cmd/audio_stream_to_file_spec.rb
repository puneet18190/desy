require 'spec_helper'

module MediaEditing
  module Video
    class Cmd
      describe AudioStreamToFile do
        let(:pre_command) { MEVSS::AVCONV_PRE_COMMAND }
        
        subject { described_class.new('inp ut', 'out put') }
        
        its(:to_s) { should == %Q[#{pre_command} -i inp\\ ut -map 0:a:0 -c copy out\\ put] }
      end
    end
  end
end