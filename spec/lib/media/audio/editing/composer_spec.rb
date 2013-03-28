require 'spec_helper'

module Media
  module Audio
    module Editing
      describe Composer do
        self.use_transactional_fixtures = false

        let(:pools) { Rails.configuration.database_configuration[Rails.env]['pool'] }

        let(:user) { User.admin }
        
        let(:components) do
          (pools+5).times.map do
            ::Audio.create!(title: 'test', description: 'test', tags: 'a,b,c,d') do |v|
              v.user  = user
              v.media = MESS::CONVERTED_AUDIO_HASH
            end
          end
        end

        let(:initial_audio_attributes) { { title: 'new title', description: 'new description', tags: 'e,f,g,h' } }

        def info(format)
          @info ||= {}
          @info[format] ||= Info.new(initial_audio.media.path(format))
        end

        describe '#run' do
          let(:params) do
            { components: components.map do |record|
              { audio: record.id,
                from:  10       ,
                to:    20      }
              end
            }
          end
          let!(:duration) do
            params[:components].map do |c|
              c[:to] - c[:from]
            end.sum
          end
          def expected_infos(format)
            MESS::AUDIO_COMPOSING[format].merge(duration: duration)
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
            
                let!(:format) { format }

                it 'creates the correct audio' do
                  info(format).similar_to?(expected_infos(format), true).should be_true
                end
              end
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
              ::Audio.find ::Audio.create!(initial_audio_attributes) { |v|
                v.user                = user
                v.media               = MESS::CONVERTED_AUDIO_HASH
                v.metadata.old_fields = { title: 'old title', description: 'old description', tags: 'a,b,c,d' }
              }
            end

            let(:user_notifications_count) { user.notifications.count }
            let(:old_files)                { initial_audio.media.paths.values.dup }

            before(:all) do
              old_files
              user.audio_editor_cache!(params_with_initial_audio)
              user_notifications_count
              described_class.new(params_with_initial_audio).run
              initial_audio.reload
            end

            MESS::AUDIO_FORMATS.each do |format|
              context "with #{format} format", format: format do
            
                let(:format) { format }

                it 'creates the correct audio' do
                  info(format).similar_to?(expected_infos(format), true).should be_true
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

            it 'deletes the old files' do
              old_files.each{ |f| File.exists?(f).should be_false }
            end

          end
        end

      end
    end
  end
end