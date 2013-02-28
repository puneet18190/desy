require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/in_tmp_dir'
require 'sensitive_thread'
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
          @creation_mode = audio.media.blank?
          old_media = !@creation_mode && audio.media.to_hash
          
          begin
            compose
          rescue StandardError => e
            if old_media
              audio.media     = old_media 
              audio.converted = true
            else
              video.converted = false
            end
            if old_fields = audio.try(:metadata).try(:old_fields)
              audio.title       = old_fields.title
              audio.description = old_fields.description
              audio.tags        = old_fields.tags
            end
            audio.save! if old_media || old_fields
            Notification.send_to audio.user_id, I18n.t("notifications.audios.#{notification_translation_key}.failed")
            raise e
          end
        end

        def compose
          in_tmp_dir do
            concats = {}

            @params[:components].each_with_index.map do |component, i|
              SensitiveThread.new do
                concats.store i, compose_audio(*component.values_at(:audio, :from, :to), i)
              end
            end.each(&:join)

            concat = tmp_path 'concat'
            outputs = Concat.new(concats.sort.map{ |_,c| c }, concat).run

            audio.media               = outputs.merge(filename: audio.title)
            audio.composing           = nil
            audio.metadata.old_fields = nil

            ActiveRecord::Base.transaction do
              audio.save!
              audio.enable_lessons_containing_me
              Notification.send_to audio.user_id, I18n.t("notifications.audios.#{notification_translation_key}.ok", audio: audio.title)
              audio.user.try(:audio_editor_cache!)
            end
          end
        end

        private
        def compose_audio(audio_id, from, to, i)
          audio = ::Audio.find audio_id
          inputs = Hash[ FORMATS.map{ |f| [f, audio.media.path(f)] } ]

          if from == 0 && to == audio.min_duration
            {}.tap do |outputs|
              inputs.map do |format, input|
                output = outputs[format] = "#{output_without_extension(i)}.#{format}"
                SensitiveThread.new{ audio_copy input, output }
              end.each(&:join)
            end
          else
            start, duration = from, to-from
            Crop.new(inputs, output_without_extension(i), start, duration).run
          end
        end

        def notification_translation_key
          @creation_mode ? 'new' : 'editing'
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