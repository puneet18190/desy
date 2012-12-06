require 'spec_helper'

module MediaEditing
  module Video
    class Transition
      class Cmd
        describe ExtractFrame do

          let(:pre_command) { MEVSS::AVCONV_PRE_COMMAND }
          let(:commands) { { mp4:  "#{pre_command} -i inp\\ ut -ss 10 -frames:v 1 out\\ put",
                             webm: "#{pre_command} -i inp\\ ut -ss 10 -frames:v 1 out\\ put" } }
          
          subject { described_class.new('inp ut', 'out put', 10) }
          
          MEVSS::FORMATS.each do |format|
            context "with #{format} format", format: format do
              let!(:format)  { format }
              let!(:command) { commands[format] }

              its(:to_s) { should == command }
            end
          end

        end
      end
    end
  end
end
