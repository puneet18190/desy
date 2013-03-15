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
        let(:audio_long) do
          ::Audio.create!(title: 'test', description: 'test', tags: 'a,b,c,d') do |v|
            v.user  = user
            v.media = MESS::CONVERTED_AUDIO_HASH_LONG
          end
        end

        let(:initial_video_attributes) { { title: 'new title', description: 'new description', tags: 'e,f,g,h' } }

        def info(format)
          @info ||= {}
          @info[format] ||= Info.new(initial_video.media.path(format))
        end


        describe '#run' do
          let(:params) do
            { audio_track: audio_track,
              components: [
                { type:  described_class::parent::Parameters::VIDEO_COMPONENT,
                  video: video.id              ,
                  from:  0                     ,
                  to:    video.min_duration   },
                { type:             described_class::parent::Parameters::TEXT_COMPONENT,
                  content:          'title'              ,
                  duration:         5                    ,
                  background_color: 'red'                ,
                  color:            'white'             },
                { type:             described_class::parent::Parameters::IMAGE_COMPONENT,
                  image:            image.id              ,
                  duration:         10                    }
              ] * 2
            }
          end
          let!(:duration) do
            params[:components].map do |c|
              case c[:type]
              when described_class::parent::Parameters::VIDEO_COMPONENT
                c[:to] - c[:from]
              when described_class::parent::Parameters::TEXT_COMPONENT, described_class::parent::Parameters::IMAGE_COMPONENT
                c[:duration]
              end
            end.sum + (params[:components].size-1)
          end
          def expected_infos(type, format)
            MESS::VIDEO_COMPOSING[type][format].merge(duration: duration)
          end
          let(:params_with_initial_video) { params.merge(initial_video: { id: initial_video.id }) }

          context 'without an uploaded initial video' do

            let(:initial_video) do
              ::Video.create!(initial_video_attributes) do |r|
                r.user      = user
                r.composing = true
              end
            end
            
            context 'without audio track' do
              let(:audio_track)              { nil }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
                initial_video.reload
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let!(:format) { format }

                  it 'creates the correct video' do
                    info(format).similar_to?(expected_infos(:without_audio_track, format), true).should be_true
                  end
                end
              end

              it 'sends a notification to the user' do
                initial_video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                initial_video.user.video_editor_cache.should be_nil
              end
            end
            
            context 'with audio track' do
              let(:audio_track) { audio.id }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
                initial_video.reload
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }

                  it 'creates the correct video' do
                    info(format).similar_to?(expected_infos(:with_audio_track, format), true).should be_true
                  end
                end
              end

              it 'sends a notification to the user' do
                initial_video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                initial_video.user.video_editor_cache.should be_nil
              end
            end

            context 'with an audio track longer than the video generated' do
              let(:audio_track) { audio_long.id }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
                initial_video.reload
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }

                  it 'creates the correct video' do
                    info(format).similar_to?(expected_infos(:with_audio_track, format), true).should be_true
                  end
                end
              end

              it 'sends a notification to the user' do
                initial_video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                initial_video.user.video_editor_cache.should be_nil
              end
            end

          end

          context 'with an uploaded initial video' do
            let(:initial_video) do
              ::Video.create!(initial_video_attributes) do |v|
                v.user                = user
                v.media               = MESS::CONVERTED_VIDEO_HASH
                v.metadata.old_fields = { title: 'old title', description: 'old description', tags: 'a,b,c,d' }
              end
            end

            context 'without audio track' do
              let(:audio_track)              { nil }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
                initial_video.reload
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }

                  it 'creates the correct video' do
                    info(format).similar_to?(expected_infos(:without_audio_track, format), true).should be_true
                  end
                end
              end

              it 'deletes the video old_fields metadata' do
                initial_video.metadata.old_fields.should be_nil
              end

              it 'sends a notification to the user' do
                initial_video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                initial_video.user.video_editor_cache.should be_nil
              end
            end

            context 'with audio track' do
              let(:audio_track)              { audio }
              let(:user_notifications_count) { user.notifications.count }

              before(:all) do
                user.video_editor_cache!(params_with_initial_video)
                user_notifications_count
                described_class.new(params_with_initial_video).run
                initial_video.reload
              end

              MESS::VIDEO_FORMATS.each do |format|
                context "with #{format} format", format: format do
              
                  let(:format) { format }

                  it 'creates the correct video' do
                    info(format).similar_to?(expected_infos(:with_audio_track, format), true).should be_true
                  end
                end
              end

              it 'deletes the video old_fields metadata' do
                initial_video.metadata.old_fields.should be_nil
              end

              it 'sends a notification to the user' do
                initial_video.user.notifications.count.should == user_notifications_count+1
              end

              it 'deletes the video editor cache' do
                initial_video.user.video_editor_cache.should be_nil
              end
            end
          end
        end

      end
    end
  end
end