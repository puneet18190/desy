require 'pathname'

require 'facter'

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

# TODO Scrivere a che serve
WINDOWS = Facter::Util::Config.is_windows?

# TODO Should be fixed; check and if it is remove
#
# # Patch to Facter in order to fix EncodingError on Windows
# module Facter::Util::Config
#   def self.windows_data_dir
#     if Dir.const_defined? 'COMMON_APPDATA' then
#       Dir::COMMON_APPDATA.encode('ASCII')
#     else
#       nil
#     end
#   end
# end
#
#
# if WINDOWS
#   require 'win32/dir'
#   # Make Dir.glob work with Pathname instances
#   class Dir
#     class << self
#       def glob(glob_pattern, flags = 0, &block)
#         glob_pattern = glob_pattern.to_s.tr("\\", "/")
#         old_glob(glob_pattern, flags, &block)
#       end
#
#       def [](glob_pattern)
#         glob_pattern = glob_pattern.to_s.tr("\\", "/")
#         old_ref(glob_pattern)
#       end
#     end
#   end
# end

# +Rails.public_pathname+ returns Rails public path as Pathname instance
module Rails
  def self.public_pathname
    @public_pathname ||= Pathname.new public_path
  end
end

# TODO Scrivere a che serve
class ActiveRecord::Base  
  def self.errors_path
    my_class = self.new.class.to_s
    my_class_path = my_class.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
    "activerecord.errors.models.#{my_class_path}"
  end
  
  def get_base_error
    self.errors.messages.has_key?(:base) ? self.errors.messages[:base].first : ''
  end
end

# HTML escaping by default using +I18n.t+
module I18n
  include ERB::Util
  
  class << self
    
    def translate_with_html_escaping(*args)
      if args[-1].is_a?(Hash)
        args[-1] = Hash[ args[-1].map{ |k,v| [k, ([:locale, :throw, :raise, :link, :resolve, :default].include?(k) ? v : ERB::Util.h(v)) ] } ]
      end
      translate_without_html_escaping(*args)
    end
    
    alias_method_chain :translate, :html_escaping
    alias_method :t, :translate_with_html_escaping
    
  end

end

# Fixes ActiveRecord bug which crashes on certain conditions when translates PostgreSQL exceptions
module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter

      protected

      def translate_exception(exception, message)
        raise exception unless exception.respond_to? :result
        case exception.result.error_field(PGresult::PG_DIAG_SQLSTATE)
        when UNIQUE_VIOLATION
          RecordNotUnique.new(message, exception)
        when FOREIGN_KEY_VIOLATION
          InvalidForeignKey.new(message, exception)
        else
          super
        end
      end
    end
  end
end