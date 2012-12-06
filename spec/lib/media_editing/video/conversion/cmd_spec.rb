require 'spec_helper'

module MediaEditing
  module Video
    class Conversion
      describe Cmd do

        let(:subexec_options) { MEVSS::AVCONV_WITH_FILTERS_SUBEXEC_OPTIONS }
        let(:pre_command)     { MEVSS::AVCONV_WITH_FILTERS_PRE_COMMAND }
      
        supported_formats = MediaEditing::Video::AVCONV_FORMATS

        describe 'class methods' do
          subject { described_class }

          its(:subexec_options) { should == subexec_options }

          describe 'new' do
            context 'with unsupported formats' do
              subject { described_class.new('in\ put', 'out\ put', :unsupported_format, double(video_streams: [], audio_streams: [])) }
              it { expect { subject }.to raise_error(MediaEditing::Video::Error) }
            end

            supported_formats.each do |format|

              context "with format #{format}" do
                context 'without any video stream' do
                  subject { described_class.new('in\ put', 'out\ put', format, double(video_streams: [], audio_streams: [])) }
                  it { expect { subject }.to raise_error(MediaEditing::Video::Error) }
                end
              end

            end
          end

        end

        describe 'streams' do

          supported_formats.each do |format|

            context "with format #{format}" do
              
              let(:ow)             { MediaEditing::Video::AVCONV_OUTPUT_WIDTH        }
              let(:oh)             { MediaEditing::Video::AVCONV_OUTPUT_HEIGHT       }
              let(:oar)            { MediaEditing::Video::AVCONV_OUTPUT_ASPECT_RATIO }
              let!(:format)        { format }
              let!(:vbitrate) { ' -b:v 2M' if format == :webm }
              let!(:cmd_format)   do
                %Q[#{pre_command} -i inp\\ ut -sn -threads #{MediaEditing::Video::AVCONV_OUTPUT_THREADS[format]} -q:v 1 -q:a #{MediaEditing::Video::AVCONV_OUTPUT_QA[format]}#{vbitrate} -c:v #{MediaEditing::Video::AVCONV_CODECS[format][0]} -c:a #{MediaEditing::Video::AVCONV_CODECS[format][1]} -map 0:v:0%s -vf 'scale=lt(iw/ih\\,#{oar})*#{ow}+gte(iw/ih\\,#{oar})*-1:lt(iw/ih\\,#{oar})*-1+gte(iw/ih\\,#{oar})*#{oh},crop=#{ow}:#{oh}:(iw-ow)/2:(ih-oh)/2' out\\ put]
              end

              context 'when audio streams are not present' do
                context 'when the first video stream' do
                  context 'has a bitrate' do
                    let(:input_file_info) { double(video_streams: [ { bitrate: 100 }, { bitrate: 'ignored' } ], audio_streams: []) }
                    subject { described_class.new('inp ut', 'out put', format, input_file_info) }
                    its(:to_s) { should == cmd_format % '' }
                  end

                  context 'has not a bitrate' do
                    let(:input_file_info) { double(video_streams: [ { bitrate: nil }, { bitrate: 'ignored' } ], audio_streams: []) }
                    subject { described_class.new('inp ut', 'out put', format, input_file_info ) }
                    its(:to_s) { should == cmd_format % '' }
                  end
                end
              end

              context 'when there is at least one audio stream and the first audio stream' do
                context 'has a bitrate' do
                  context 'when the first video stream' do
                    context 'has a bitrate' do
                      let(:input_file_info) { double(video_streams: [ { bitrate: 100 }, { bitrate: 'ignored' } ], audio_streams: [ { bitrate: 50 }, { bitrate: 'ignored' } ]) }
                      subject { described_class.new('inp ut', 'out put', format, input_file_info) }
                      its(:to_s) { should == cmd_format % ' -map 0:a:0' }
                    end

                    context 'has not a bitrate' do
                      let(:input_file_info) { double(video_streams: [ { bitrate: nil }, { bitrate: 'ignored' } ], audio_streams: [ { bitrate: 50 }, { bitrate: 'ignored' } ]) }
                      subject { described_class.new('inp ut', 'out put', format, input_file_info ) }
                      its(:to_s) { should == cmd_format % ' -map 0:a:0' }
                    end
                  end
                end

              end

            end
          end

        end

      end

    end
  end
end
