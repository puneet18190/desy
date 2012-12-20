require 'spec_helper'

module Media
  module Video
    module Editing
      describe Composer do
        self.use_transactional_fixtures = false

        let(:video) do
          ::Video.create!(title: 'test', description: 'test', tags: 'a,b,c,d' ) do |v|
            v.user  = User.admin
            v.media = MESS::CONVERTED_VIDEO_HASH
          end
        end
        let(:image) do
          ::Image.create!(title: 'test', description: 'test', tags: 'a,b,c,d' ) do |v|
            v.user  = User.admin
            v.media = File.open(MESS::VALID_JPG)
          end
        end
        let(:audio) do
          ::Audio.create!(title: 'test', description: 'test', tags: 'a,b,c,d' ) do |v|
            v.user  = User.admin
            v.media = MESS::CONVERTED_AUDIO_HASH
          end
        end

        describe '#run' do
          let(:params) do
            { initial_video: initial_video,
              audio_track: audio_track,
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
          context 'without initial video' do
            let(:initial_video) { { title: 'test', description: 'test', tags: 'a,b,c,d', user_id: User.admin.id } }
            context 'without audio track' do
              let(:audio_track) { nil }
              it 'works' do
                expect{ described_class.new(params).run }.to_not raise_error
              end
            end
            context 'with audio track' do
              let(:audio_track) { audio }
              it 'works' do
                expect{ described_class.new(params).run }.to_not raise_error
              end
            end
          end

          context 'with initial video' do
            let(:initial_video) do
              video = ::Video.create!(title: 'title', description: 'description', tags: 'a,b,c,d' ) do |v|
                v.user  = User.admin
                v.media = MESS::CONVERTED_VIDEO_HASH
              end
              { id: video.id, title: 'title 2', description: 'description 2', tags: 'e,f,g,h' }
            end
            context 'without audio track' do
              let(:audio_track) { nil }
              it 'works' do
                expect{ described_class.new(params).run }.to_not raise_error
              end
            end
            context 'with audio track' do
              let(:audio_track) { audio }
              it 'works' do
                expect{ described_class.new(params).run }.to_not raise_error
              end
            end
          end
        end

      end
    end
  end
end