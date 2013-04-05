require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/logging'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/thread'
require 'media/video/editing/cmd/audio_stream_to_file'
require 'media/video/editing/cmd/m4a_to_wav'
require 'media/audio/editing/cmd/concat'
require 'media/video/editing/cmd/merge_webm_video_streams'
require 'media/video/editing/cmd/concat'

module Media
  module Video
    module Editing
      class Concat
  
        include Logging
        include InTmpDir
  
        CONCAT_M4A_FORMAT      = 'concat%i.m4a'
        CONCAT_WAV_FORMAT      = 'concat%i.wav'
        FINAL_WAV              = 'final.wav'
        FINAL_WEBM_NO_AUDIO    = 'final_webm_no_audio.webm'
        OUTPUT_MP4_FORMAT      = '%s.mp4'
        OUTPUT_WEBM_FORMAT     = '%s.webm'
        
        # Usage example:
        #
        # Concat.new([ { webm: 'input.webm', mp4: 'input.mp4'}, { webm: 'input2.webm', mp4: 'input2.mp4'} ], '/output/without/extension').run 
        #
        #   #=> { mp4:'/output/without/extension.mp4', webm:'/output/without/extension.webm' }
        #
        def initialize(inputs, output_without_extension, log_folder = nil)
          unless inputs.is_a?(Array) &&
                 inputs.present?     &&
                 inputs.all? do |input|
                   input.is_a?(Hash)                 &&
                   input.keys.sort == FORMATS.sort   &&
                   input.values.size == FORMATS.size &&
                   input.values.all?{ |v| v.is_a?(String) }
                 end
            raise Error.new( "inputs must be an array with at least one element and its elements must be hashes with #{FORMATS.inspect} as keys and strings as values", 
                             inputs: inputs, output_without_extension: output_without_extension )
          end
  
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
          end
  
          @inputs, @output_without_extension = inputs, output_without_extension
          
          if mp4_inputs.size != webm_inputs.size
            raise Error.new('mp4_inputs and webm_inputs must be of the same size', inputs: @inputs, output_without_extension: @output_without_extension)
          end

          @log_folder = log_folder
        end
  
        def run
          # Posso controllare mp4_inputs per sapere quante coppie di video ho, perché ho già visto che mp4_inputs.size == webm_inputs.size
          # Caso speciale: se ho una sola coppia di input copio i due video nei rispettivi output e li ritorno
          return copy_first_inputs_to_outputs if mp4_inputs.size == 1
  
          mp4_inputs_infos = mp4_inputs.map{ |input| Info.new(input) }
          paddings = paddings mp4_inputs_infos
          final_videos = nil
  
          in_tmp_dir { final_videos = concat(mp4_inputs_infos, paddings) }
  
          final_videos
        end
  
        private
        def copy_first_inputs_to_outputs
          Hash[
            @inputs.first.map do |format, input|
              output = outputs[format]
              FileUtils.cp input, output
              [format, output]
            end
          ]
        end
  
        # Core della concatenazione
        #
        #   1. se c'è almeno uno stream audio
        #     a. genero il file wav dell'audio
        #     b. altrimenti no
        #   2. genero la traccia video concatenando le tracce video dei webm e scartando le relative tracce audio; dopo questa
        #      operazione avrò la traccia audio in formato wav e la traccia video in formato webm dei video finale
        #   3. genero i video mp4 e webm unendo le due tracce e convertendo la traccia video e l'eventuale traccia audio
        def concat(mp4_inputs_infos, paddings)
          create_log_folder
  
          final_wav = 
            if mp4_inputs_infos.any?{ |info| info.audio_streams.present? } # 1.
              final_wav(mp4_inputs_infos, paddings) # 1.a
            else
              nil # 1.b
            end
  
          final_webm_no_audio = tmp_path FINAL_WEBM_NO_AUDIO
          Cmd::MergeWebmVideoStreams.new(webm_inputs, final_webm_no_audio).run! *logs('3_merge_webm_video_streams') # 2.
  
          final_webm_no_audio_info = Info.new final_webm_no_audio

          Thread.join *FORMATS.map { |format|
            proc {
              Cmd::Concat.new(final_webm_no_audio, final_wav, final_webm_no_audio_info.duration, outputs[format], format).run! *logs("4_#{format}") # 3.
            }
          }
  
          outputs
        end
  
        # Generazione traccia audio
        #
        #   1. estraggo gli m4a dagli mp4
        #   2. li converto in wav (le operazioni di taglia e cuci sono più precise se effettuate su formati lossless)
        #   3. aumento l'rpadding nel caso la traccia wave sia sensibilmente più corta della traccia video corrispondente
        #   4. associo il wav ai paddings corrispondenti
        #   5. concateno i wavs aggiungendo i paddings
        def final_wav(mp4_inputs_infos, paddings)
          wavs_with_paddings = wavs_with_paddings(mp4_inputs_infos, paddings)
          final_wav = tmp_path FINAL_WAV
          Audio::Editing::Cmd::Concat.new(wavs_with_paddings, final_wav).run! *logs('2_concat_with_paddings') # 5.
          final_wav
        end

        def wavs_with_paddings(mp4_inputs_infos, paddings)
          Hash[ {}.tap do |unordered_wavs_with_paddings|
            Thread.join *mp4_inputs_infos.select{ |info| info.audio_streams.present? }.each_with_index.map { |video_info, i|
              proc {
                m4a = tmp_path(CONCAT_M4A_FORMAT % i)
          
                Cmd::AudioStreamToFile.new(video_info.path, m4a).run! *logs("0_audio_stream_to_file_#{i}") # 1.
          
                wav = tmp_path(CONCAT_WAV_FORMAT % i)
                Cmd::M4aToWav.new(m4a, wav).run! *logs("1_m4a_to_wav_#{i}") # 2.
                
                # aumento l'rpadding nel caso che la traccia video sia sensibilmente più lunga della traccia audio
                # tenendo in considerazione che l'operazione di encoding aggiunge un rpadding di suo
                increase_rpadding_depending_on_video_overflow video_info, wav, paddings[i] # 3.
          
                unordered_wavs_with_paddings[i] = wav, paddings[i] # 4.
              }
            }
          end.sort.map{ |_, wavs_with_paddings| wavs_with_paddings } ]
        end
  
        def increase_rpadding_depending_on_video_overflow(video_info, wav, paddings)
          wav_info = Info.new(wav)
          overflow = video_info.duration - wav_info.duration
          paddings[1] += overflow if overflow > 0
        end
  
        # Lo scopo di questo metodo è di calcolare i paddings (i delays) da dare alle tracce audio estratte
        # in modo da avere come risultato una traccia audio lunga quanto la somma della durata dei video
        # e che sia sincronizzata con i video. Es.:
        #
        #                        VIDEO
        #
        # |----|-----|----|---|----|------|------|----|-----|   TRACCE VIDEO
        #      |-a0--|    |a1-|-a2-|             |-a3-|         TRACCE AUDIO
        #   p0         p1    p2=0         p3             p4       PADDINGS
        #
        #              a0      a1        a2      a3
        #    ->   [ [p0,p1], [0,p2=0], [0,p3], [0,p4] ]           RISULTATO
        #
        def paddings(infos)
          paddings, lpadding = [], 0
  
          infos.each do |info|
            if info.audio_streams.blank?
              if paddings.blank?
                lpadding         += info.duration
              else
                paddings.last[1] += info.duration
              end
              next
            end
  
            paddings << [lpadding, 0]
            lpadding = 0
          end

          paddings
        end
  
        def mp4_inputs
          @mp4_inputs ||= @inputs.map{ |input| input[:mp4] }
        end
  
        def webm_inputs
          @webm_inputs ||= @inputs.map{ |input| input[:webm] }
        end
  
        def mp4_output
          OUTPUT_MP4_FORMAT % @output_without_extension
        end
  
        def webm_output
          OUTPUT_WEBM_FORMAT % @output_without_extension
        end
  
        def outputs
          { mp4: mp4_output, webm: webm_output }
        end
  
      end
    end
  end
end
