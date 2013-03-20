require 'media'

module Media
  module InTmpDir
  
    def in_tmp_dir
      Dir.mktmpdir(CONFIG.tmp_prefix) do |dir|
        @tmp_dir = dir
        yield
      end
    ensure
      @tmp_dir = nil
    end

    def tmp_path(path)
      raise Error.new('@tmp_dir must be present', path: path) unless @tmp_dir
      File.join(@tmp_dir, path)
    end

  end
end