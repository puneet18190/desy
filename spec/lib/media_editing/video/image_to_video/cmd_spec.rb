require 'spec_helper'

module MediaEditing
  module Video
    class ImageToVideo
      describe Cmd do
        
        supported_formats = MediaEditing::Video::AVCONV_FORMATS

        let(:pre_command) { MEVSS::AVCONV_PRE_COMMAND }
        let(:vbitrate) { MEVSS::VBITRATE }

        supported_formats.each do |format|
          context "with #{format} format", format: format do

          subject { described_class.new('in put', 'out put', format, 123.456) }

          its(:to_s) { should == "#{pre_command} -loop 1 -i in\\ put -sn -threads #{MediaEditing::Video::AVCONV_OUTPUT_THREADS[format]} -q:v 1#{vbitrate[format]} -c:v #{MediaEditing::Video::AVCONV_CODECS[format][0]} -t 123.46 out\\ put" }
          end
        end
        
      end
    end
  end
end