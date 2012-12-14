require 'spec_helper'

module MediaEditing
  module Video
    class Cmd
      describe Crop do

        let(:pre_command) { MESS::AVCONV_PRE_COMMAND }
        let(:command) do
          { mp4:  "#{pre_command} -i in\\ put -sn -threads #{AVCONV_OUTPUT_THREADS[:mp4]} -q:v 1 -q:a 4 -c:v libx264 -c:a libmp3lame -ss 10.0 -t 20.0 out\\ put",
            webm: "#{pre_command} -i in\\ put -sn -threads #{AVCONV_OUTPUT_THREADS[:webm]} -q:v 1 -q:a 5 -b:v 2M -c:v libvpx -c:a libvorbis -ss 10.0 -t 20.0 out\\ put" }
        end
        
        MESS::FORMATS.each do |format|

          context "with #{format} format", format: format do
            let(:format) { format }
          
            subject { described_class.new('in put', 'out put', 10, 20, format) }

            its(:to_s) { should == command[format] }
          end

        end

      end
    end
  end
end