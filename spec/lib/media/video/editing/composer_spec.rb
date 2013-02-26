require 'spec_helper'

module Media
  module Video
    module Editing
      describe Composer do
        self.use_transactional_fixtures = false

        let(:user) { User.admin }

        let(:video) do
          ::Video.create!(title: 'test', description: 'test', tags: 'a,b,c,d') do |v|
            v.user  = user
            v.media = MESS::CONVERTED_VIDEO_HASH
          end
        end
        let(:image) do
          ::Image.create!(title: 'test', description: 'test', tags: 'a,b,c,d') do |v|
            v.user  = user
            v.media = File.open(MESS::VALID_JPG)
          end
        end
        let(:audio) do
          ::Audio.create!(title: 'test', description: 'test', tags: 'a,b,c,d') do |v|
            v.user  = user
            v.media = MESS::CONVERTED_AUDIO_HASH
          end
        end

        describe '#run' do
          let(:params) do
            { audio_track: audio_track,
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
          let(:params_with_initial_video) { params.merge(initial_video: initial_video) }

          context 'without initial video' do

            let(:initial_video) do
              record = ::Video.create!(title: 'new title', description: 'new description', tags: 'e,f,g,h') do |r|
                r.user               = user
                r.composing          = params
              end
              { id: record.id }
            end
            
            context 'without audio track' do
              let(:audio_track)              { nil }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }
                  def info(format)
                    @info ||= {}
                    @info[format] ||= Info.new(video.media.path(format)).to_hash.reject{ |k,_| k == :path }
                  end

                  it 'creates the correct video' do
                    info(format).should == MESS::VIDEO_COMPOSING[format]
                  end
                end
              end

              it 'deletes the video composing metadata' do
                video.reload.composing.should be_nil
              end

              it 'sends a notification to the user' do
                video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                video.user.reload.video_editor_cache.should be_nil
              end
            end
            
            context 'with audio track' do
              let(:audio_track) { audio }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }
                  def info(format)
                    @info ||= {}
                    @info[format] ||= Info.new(video.media.path(format)).to_hash.reject{ |k,_| k == :path }
                  end

                  it 'creates the correct video' do
                    info(format).should == MESS::VIDEO_COMPOSING[format]
                  end
                end
              end

              it 'deletes the video composing metadata' do
                video.reload.composing.should be_nil
              end

              it 'sends a notification to the user' do
                video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                video.user.reload.video_editor_cache.should be_nil
              end
            end

          end

          context 'with initial video' do
            let(:initial_video) do
              video = ::Video.create!(title: 'new title', description: 'new description', tags: 'e,f,g,h') do |v|
                v.user                = user
                v.media               = MESS::CONVERTED_VIDEO_HASH
                v.metadata.old_fields = { title: 'old title', description: 'old description', tags: 'a,b,c,d' }
              end
              { id: video.id, title: 'title 2', description: 'description 2', tags: 'e,f,g,h' }
            end

            context 'without audio track' do
              let(:audio_track)              { nil }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }
                  def info(format)
                    @info ||= {}
                    @info[format] ||= Info.new(video.media.path(format)).to_hash.reject{ |k,_| k == :path }
                  end

                  it 'creates the correct video' do
                    info(format).should == MESS::VIDEO_COMPOSING[format]
                  end
                end
              end

              it 'deletes the video old_fields metadata' do
                video.metadata.old_fields.should be_nil
              end

              it 'sends a notification to the user' do
                video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                video.user.reload.video_editor_cache.should be_nil
              end
            end

            context 'with audio track' do
              let(:audio_track)              { audio }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }
                  def info(format)
                    @info ||= {}
                    @info[format] ||= Info.new(video.media.path(format)).to_hash.reject{ |k,_| k == :path }
                  end

                  it 'creates the correct video' do
                    info(format).should == MESS::VIDEO_COMPOSING[format]
                  end
                end
              end

              it 'deletes the video old_fields metadata' do
                video.metadata.old_fields.should be_nil
              end

              it 'sends a notification to the user' do
                video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                video.user.reload.video_editor_cache.should be_nil
              end
            end
          end
        end

      end
    end
  end
end