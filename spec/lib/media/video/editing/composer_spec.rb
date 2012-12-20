require 'spec_helper'

module Media
  module Video
    module Editing
      describe Composer do

        let(:video) do
          ::Video.create!(title: 'test', description: 'test', tags: 'a,b,c,d,e' ) do |v|
            v.user  = User.admin
            v.media = MESS::CONVERTED_VIDEO_HASH
          end
        end
        let(:image) do
          ::Image.create!(title: 'test', description: 'test', tags: 'a,b,c,d,e' ) do |v|
            v.user  = User.admin
            v.media = File.open(MESS::VALID_JPG)
          end
        end
        let(:params) do
          { initial_video: { title:       'test', 
                             description: 'test', 
                             tags:        'a,b,c,d,e' },
            audio_track: nil,
            components: [
              { type:  described_class::VIDEO_COMPONENT,
                video: video.id              ,
                from:  0                     ,
                to:    video.min_duration   },
              { type:             described_class::TEXT_COMPONENT,
                content:          'title'              ,
                duration:         5                    ,
                background_color: 'red'                ,
                color:            'white'             },
              { type:             described_class::IMAGE_COMPONENT,
                image:            image.id              ,
                duration:         10                    }
            ]
          }
        end

        # before do
          # video
          # puts video.valid?
          # puts video.inspect
          # image
          # sleep 0.25
        # end

        it 'works' do
          expect{ described_class.new(params).run }.to_not raise_error
        end

      end
    end
  end
end