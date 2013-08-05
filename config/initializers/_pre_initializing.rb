require 'dumpable'
require 'controller_info'
require 'errors_logger'

# Patch to Arel::Nodes:SqlLiteral which allows to dump it using Psych
module Arel
  module Nodes
    class SqlLiteral < String
      def encode_with(coder)
        coder['string'] = self.to_s
      end
      def init_with(coder)
        self << coder['string']
      end
    end
  end
end

# Patch to Facter in order to fix EncodingError on Windows
require 'facter'
module Facter::Util::Config
  def self.windows_data_dir
    if Dir.const_defined? 'COMMON_APPDATA' then
      Dir::COMMON_APPDATA.encode('ASCII')
    else
      nil
    end
  end
end

WINDOWS = Facter::Util::Config.is_windows?

if WINDOWS
  require 'win32/dir'
  # Make Dir.glob work with Pathname instances
  class Dir
    class << self
      def glob(glob_pattern, flags = 0, &block)
        glob_pattern = glob_pattern.to_s.tr("\\", "/")
        old_glob(glob_pattern, flags, &block)
      end

      def [](glob_pattern)
        glob_pattern = glob_pattern.to_s.tr("\\", "/")
        old_ref(glob_pattern)
      end
    end
  end
end