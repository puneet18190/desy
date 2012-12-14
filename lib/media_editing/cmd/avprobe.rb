require 'media_editing'
require 'media_editing/cmd'
require 'shellwords'

module MediaEditing
  class Cmd
    class Avprobe < Cmd
      # TODO spostare le config di MediaEditing::Video in MediaEditing
      require 'media_editing/video'
      SH_VARS         = Hash[ MediaEditing::Video::CONFIG.avtools.avprobe.cmd.sh_vars.marshal_dump.map{ |k, v| [k.to_s, v] } ]
      BIN             = MediaEditing::Video::CONFIG.avtools.avprobe.cmd.bin
      SUBEXEC_OPTIONS = { sh_vars: SH_VARS, timeout: MediaEditing::Video::AVPROBE_SUBEXEC_TIMEOUT }
      
      @subexec_options = SUBEXEC_OPTIONS

      def initialize(input_file)
        @input_file = input_file
      end

      def run(stdout = nil, stderr = nil)
        super
      end

      private
      def cmd!
        %Q[ #{BIN.shellescape} #{@input_file.shellescape} ].squish
      end

    end
  end
end