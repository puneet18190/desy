require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/in_tmp_dir'
require 'media/thread'
require 'media/audio/editing/crop'
require 'media/audio/editing/concat'

module Media
  module Audio
    module Editing
      class Composer

        include InTmpDir

        #  {
        #    :initial_audio => OBJECT OF TYPE AUDIO or NIL,
        #    :components => [
        #      {
        #        :audio => OBJECT OF TYPE AUDIO,
        #        :from => 12,
        #        :to => 24
        #      },
        #      {
        #        etc...
        #      }
        #    ]
        #  }
        def initialize(params)
          @params = params
        end

        def run
          @overwrite = audio.media.present?
          old_media = @overwrite && audio.media.to_hash
          compose
        rescue StandardError => e
          if old_media
            audio.media     = old_media
            audio.converted = true
            if old_fields = audio.try(:metadata).try(:old_fields)
              audio.title       = old_fields['title'] if old_fields['title'].present?
              audio.description = old_fields['description'] if old_fields['description'].present?
              audio.tags        = old_fields['tags'] if old_fields['tags'].present?
            end
            audio.save!
            audio.enable_lessons_containing_me
            Notification.send_to audio.user_id, I18n.t('notifications.audio.compose.update.failed', item: audio.title, link: ::Audio::CACHE_RESTORE_PATH)
          else
            audio.destroyable_even_if_not_converted = true
            audio.destroy
            Notification.send_to audio.user_id, I18n.t('notifications.audio.compose.create.failed', item: audio.title, link: ::Audio::CACHE_RESTORE_PATH)
          end
          raise e
        end

        def compose
          in_tmp_dir do
            concats = {}.tap do |concats|
              Thread.join *@params[:components].each_with_index.map { |component, i|
                proc{ concats.store i, compose_audio(*component.values_at(:audio, :from, :to), i) }
              }
            end

            concat = tmp_path 'concat'
            outputs = Concat.new(concats.sort.map{ |_,c| c }, concat).run

            audio.media               = outputs.merge(filename: audio.title)
            audio.composing           = nil
            audio.metadata.old_fields = nil

            ActiveRecord::Base.transaction do
              audio.save!
              audio.enable_lessons_containing_me
              Notification.send_to audio.user_id, I18n.t("notifications.audio.compose.#{notification_translation_key}.ok", item: audio.title)
              audio.user.audio_editor_cache!
            end
          end
        end

        private
        def compose_audio(audio_id, from, to, i)
          audio = ::Audio.find audio_id
          inputs = Hash[ FORMATS.map{ |f| [f, audio.media.path(f)] } ]

          if from == 0 && to == audio.min_duration
            {}.tap do |outputs|
              Thread.join *inputs.map { |format, input| proc { audio_copy input, (outputs[format] = "#{output_without_extension(i)}.#{format}") } }
            end
          else
            start, duration = from, to-from
            Crop.new(inputs, output_without_extension(i), start, duration).run
          end
        end

        def audio_copy(input, output)
          FileUtils.cp(input, output)
        end

        def notification_translation_key
          @overwrite ? 'update': 'create'
        end

        def output_without_extension(i)
          tmp_path i.to_s
        end

        def audio
          @audio ||= ::Audio.find @params[:initial_audio][:id]
        end

      end
    end
  end
end
