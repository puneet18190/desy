require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/logging'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/video/editing/cmd/audio_stream_to_file'
require 'media/video/editing/cmd/mp3_to_wav'
require 'media/video/editing/cmd/concat_wavs_with_paddings'
require 'media/video/editing/cmd/merge_webm_video_streams'
require 'media/video/editing/cmd/concat/mp4'
require 'media/video/editing/cmd/concat/webm'

module Media
  module Video
    module Editing
      class Concat
  
        include Logging
        include InTmpDir
  
        # Durata del padding alla fine del file aggiunto da lame durante la codifica
        # In genere lame aggiunge un pad di massimo 0.04, per cui lo settiamo a 0.05 per stare sicuri di non tagliare troppo
        LAME_ENCODING_RPADDING = 0.05
        CONCAT_MP3_FORMAT      = 'concat%i.mp3'
        CONCAT_WAV_FORMAT      = 'concat%i.wav'
        FINAL_WAV              = 'final.wav'
        FINAL_WEBM_NO_AUDIO    = 'final_webm_no_audio.webm'
        OUTPUT_MP4_FORMAT      = '%s.mp4'
        OUTPUT_WEBM_FORMAT     = '%s.webm'
        
        # Usage example:
        #
        # Concat.new({ mp4:['concat1.mp4','concat2.mp4'], webm:['concat1.webm','concat2.webm'] }, '/output_without_extension').run 
        #
        #   #=> { mp4:'/output_without_extension.mp4', webm:'/output_without_extension.webm' }
        #
        def initialize(inputs, output_without_extension)
  
          unless inputs.is_a?(Hash)                                                     and 
                 inputs.keys.sort == FORMATS.sort                                       and
                 inputs.values.all?{ |v| v.is_a? Array }                                and
                 inputs.values.map{ |v| v.all?{ |_v| _v.is_a? String } }.uniq == [true]
            raise Error.new("inputs must be an Hash with #{FORMATS.inspect} as keys and an array of strings as values with at least one value", inputs: inputs, output_without_extension: output_without_extension)
          end
  
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
          end
  
          @inputs, @output_without_extension = inputs, output_without_extension
          
          if mp4_inputs.size != webm_inputs.size
            raise Error.new('inputs[:mp4] and inputs[:webm] must be of the same size', inputs: @inputs, output_without_extension: @output_without_extension)
          end
  
        end
  
        def run
          # Posso controllare mp4_inputs per sapere quante coppie di video ho, perché ho già visto che mp4_inputs.size == webm_inputs.size
          # Caso speciale: se ho una sola coppia di input copio i due video nei rispettivi output e li ritorno
          return copy_first_inputs_to_outputs if mp4_inputs.size == 1
  
          mp4_inputs_infos = mp4_inputs.map{ |input| Info.new(input) }
          paddings = paddings mp4_inputs_infos
          final_videos = nil
  
          in_tmp_dir do
            final_videos = concat(mp4_inputs_infos, paddings)
          end
  
          final_videos
        end
  
        private
        def copy_first_inputs_to_outputs
          Hash[
            @inputs.map do |format, inputs|
              input, output = inputs.first, outputs[format]
              FileUtils.cp input, output
              [format, output]
            end
          ]
        end
  
        # Core della concatenazione
        #
        #   1. se c'è almeno uno stream audio
        #     a. genero il file wav dell'audio
        #   2. genero la traccia video concatenando le tracce video dei webm e scartando le relative tracce audio; dopo questa
        #      operazione avrò la traccia audio in formato wav e la traccia video in formato webm dei video finale
        #   3. genero il video mp4 unendo le due tracce e convertendo la traccia video e l'eventuale traccia audio
        #   4. genero il video webm unendo le due tracce e convertendo l'eventuale traccia audio
        def concat(mp4_inputs_infos, paddings)
          create_log_folder
  
          final_wav = 
            if mp4_inputs_infos.any?{ |info| info.audio_streams.present? } # 1.
              final_wav(mp4_inputs_infos, paddings) # 1.a
            else
              nil
            end
  
          final_webm_no_audio = tmp_path FINAL_WEBM_NO_AUDIO
          Cmd::MergeWebmVideoStreams.new(webm_inputs, final_webm_no_audio).run! *logs('3_merge_webm_video_streams') # 2.
  
          final_webm_no_audio_info = Info.new final_webm_no_audio
  
          [ 
            ( Thread.new do
                Cmd::Concat::Mp4.new(final_webm_no_audio, final_wav, final_webm_no_audio_info.duration, mp4_output).run! *logs('4_mp4') # 3.
              end.tap{ |t| t.abort_on_exception = true } ),
            
            ( Thread.new do
                Cmd::Concat::Webm.new(final_webm_no_audio, final_wav, final_webm_no_audio_info.duration, webm_output).run! *logs('4_webm') # 4.
              end.tap{ |t| t.abort_on_exception = true } )
  
          ].each(&:join)
  
          { mp4: mp4_output, webm: webm_output }
        end
  
        # Generazione traccia audio
        #
        #   1. estraggo gli mp3 dagli mp4
        #   2. li converto in wav (le operazioni di taglia e cuci sono più precise se effettuate su formati lossless)
        #   3. aumento l'rpadding nel caso la traccia wave sia sensibilmente più corta della traccia video corrispondente
        #   4. associo il wav ai paddings corrispondenti
        #   5. concateno i wavs aggiungendo i paddings
        def final_wav(mp4_inputs_infos, paddings)
          wavs_with_paddings = {}
  
          mp4_inputs_infos.select{ |info| info.audio_streams.present? }.each_with_index.map do |video_info, i|
            Thread.new do
              mp3 = tmp_path(CONCAT_MP3_FORMAT % i)
  
              Cmd::AudioStreamToFile.new(video_info.path, mp3).run! *logs("0_audio_stream_to_file_#{i}") # 1.
  
              wav = tmp_path(CONCAT_WAV_FORMAT % i)
              Cmd::Mp3ToWav.new(mp3, wav).run! *logs("1_mp3_to_wav_#{i}") # 2.
              
              # aumento l'rpadding nel caso che la traccia video sia sensibilmente più lunga della traccia audio
              # tenendo in considerazione che l'operazione di encoding aggiunge un rpadding di suo
              increase_rpadding_depending_on_video_overflow video_info, wav, paddings[i] # 3.
  
              wavs_with_paddings[wav] = paddings[i] # 4.
            end.tap{ |t| t.abort_on_exception = true }
          end.each(&:join)
  
          final_wav = tmp_path FINAL_WAV
          Cmd::ConcatWavsWithPaddings.new(wavs_with_paddings, final_wav).run! *logs('2_concat_wavs_with_paddings') # 5.
          final_wav
        end
  
        def increase_rpadding_depending_on_video_overflow(video_info, wav, paddings)
          wav_info = Info.new(wav)
          overflow = video_info.duration - wav_info.duration - LAME_ENCODING_RPADDING
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
        #              a0      a1      a2      a3
        #    ->   [ [p0,p1], [0,p2], [0,p3], [0,p4] ]            RISULTATO
        #
        def paddings(infos)
          paddings, lpadding = [], 0
  
          infos.each do |info|
            if info.audio_streams.empty?
              if paddings.empty?
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
          @inputs[:mp4]
        end
  
        def webm_inputs
          @inputs[:webm]
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
