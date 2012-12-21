require 'media_editing'
require 'media_editing/video'

module MediaEditing
  module Video
    module InTmpDir
    
      def in_tmp_dir
        Dir.mktmpdir(MediaEditing::Video::TMP_PREFIX) do |dir|
          @tmp_dir = dir
          yield
        end
      ensure
        @tmp_dir = nil
      end

      def tmp_path(path)
        raise MediaEditing::Video::Error.new('@tmp_dir must be present') if @tmp_dir.blank?
        File.join(@tmp_dir, path)
      end

    end
  end
end