require 'spec_helper'

module Media
  module Audio
    module Editing
      describe Composer do
        self.use_transactional_fixtures = false

        let(:user) { User.admin }

        let(:audio1) do
          ::Audio.create!(title: 'test', description: 'test', tags: 'a,b,c,d') do |v|
            v.user  = user
            v.media = MESS::CONVERTED_AUDIO_HASH
          end
        end
        let(:audio2) do
          ::Audio.create!(title: 'test', description: 'test', tags: 'a,b,c,d') do |v|
            v.user  = user
            v.media = MESS::CONVERTED_AUDIO_HASH
          end
        end

        let(:initial_audio_attributes) { { title: 'new title', description: 'new description', tags: 'e,f,g,h' } }

        def info(format)
          @info ||= {}
          @info[format] ||= Info.new(initial_audio.media.path(format))
        end

        describe '#run' do
          let(:params) do
            { components: [
                { audio: audio1.id              ,
                  from:  10                     ,
                  to:    20                    },
                { audio: audio2.id              ,
                  from:  10                     ,
                  to:    20                    }
              ]
            }
          end
          let(:params_with_initial_audio) { params.merge(initial_audio: { id: initial_audio.id }) }

          context 'without an uploaded initial audio' do

            let(:initial_audio) do
              ::Audio.create!(initial_audio_attributes) do |r|
                r.user      = user
                r.composing = true
              end
            end
            
            let(:user_notifications_count) { user.notifications.count }

            before(:all) do
              user.audio_editor_cache!(params_with_initial_audio)
              user_notifications_count
              described_class.new(params_with_initial_audio).run
              initial_audio.reload
            end

            MESS::AUDIO_FORMATS.each do |format|
              context "with #{format} format", format: format do
            
                let(:format) { format }

                it 'creates the correct audio' do
                  info(format).similar_to?(MESS::AUDIO_COMPOSING[format]).should be_true
                end
              end
            end

            it 'deletes the audio composing metadata' do
              initial_audio.composing.should be_nil
            end

            it 'sends a notification to the user' do
              initial_audio.user.notifications.count.should == user_notifications_count+1
            end

            it 'deletes the audio editor cache' do
              initial_audio.user.audio_editor_cache.should be_nil
            end

          end

          context 'with an uploaded initial audio' do
            let(:initial_audio) do
              ::Audio.create!(initial_audio_attributes) do |v|
                v.user                = user
                v.media               = MESS::CONVERTED_AUDIO_HASH
                v.metadata.old_fields = { title: 'old title', description: 'old description', tags: 'a,b,c,d' }
              end
            end

            let(:user_notifications_count) { user.notifications.count }

            before(:all) do
              user.audio_editor_cache!(params_with_initial_audio)
              user_notifications_count
              described_class.new(params_with_initial_audio).run
              initial_audio.reload
            end

            MESS::AUDIO_FORMATS.each do |format|
              context "with #{format} format", format: format do
            
                let(:format) { format }

                it 'creates the correct audio' do
                  info(format).similar_to?(MESS::AUDIO_COMPOSING[format]).should be_true
                end
              end
            end

            it 'deletes the audio old_fields metadata' do
              initial_audio.metadata.old_fields.should be_nil
            end

            it 'sends a notification to the user' do
              initial_audio.user.notifications.count.should == user_notifications_count+1
            end

            it 'deletes the audio editor cache' do
              initial_audio.user.audio_editor_cache.should be_nil
            end

          end
        end

      end
    end
  end
end