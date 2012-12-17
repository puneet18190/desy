require 'spec_helper'

module Media
  describe Info do

    context "when the video is not valid" do
      describe 'new' do
        subject { described_class.new(MESS::INVALID_VIDEO) }
        it { expect { subject }.to raise_error(Error) }
      end
    end    

    context "when the video is valid" do
      subject { described_class.new(MESS::VALID_VIDEO) }

      it "parses video duration" do
        subject.duration.should == 38.17
      end
      it "parses video streams" do
        subject.video_streams.should == [{ codec: 'flv', width: 426, height: 240, bitrate: 200 }]
      end
      it "parses audio streams" do
        subject.audio_streams.should == [{ codec: 'adpcm_swf', bitrate: 176 }]
      end
    end

  end
end
