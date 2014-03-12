require 'pathname'

WINDOWS = Gem.win_platform?

# Patch to Arel::Nodes:SqlLiteral which allows to dump it using Psych
# TODO check if useful
# module Arel
#   module Nodes
#     class SqlLiteral < String
#       def encode_with(coder)
#         coder['string'] = self.to_s
#       end
#       def init_with(coder)
#         self << coder['string']
#       end
#     end
#   end
# end

# TODO Should be fixed; check and if it is remove
#
# if WINDOWS
#   require 'facter'
#
#   # Patch to Facter in order to fix EncodingError on Windows
#   module Facter::Util::Config
#     def self.windows_data_dir
#       if Dir.const_defined? 'COMMON_APPDATA' then
#         Dir::COMMON_APPDATA.encode('ASCII')
#       else
#         nil
#       end
#     end
#   end
#
#   require 'win32/dir'
#   # Make Dir.glob work with Pathname instances
#   class Dir
#     class << self
#       def glob(glob_pattern, flags = 0, &block)
#         glob_pattern = glob_pattern.to_s.tr("\\", "/")
#         old_glob(glob_pattern, flags, &block)
#       end

#       def [](glob_pattern)
#         glob_pattern = glob_pattern.to_s.tr("\\", "/")
#         old_ref(glob_pattern)
#       end
#     end
#   end
# end

# +Rails+ patches
module Rails
  # +Rails.public_pathname+ returns Rails public path as Pathname instance
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

# Fixes ActiveRecord bug which crashes on certain conditions when translates PostgreSQL exceptions
# TODO check if useful
# module ActiveRecord
#   module ConnectionAdapters
#     class PostgreSQLAdapter

#       protected

#       def translate_exception(exception, message)
#         raise exception unless exception.respond_to? :result
#         case exception.result.error_field(PGresult::PG_DIAG_SQLSTATE)
#         when UNIQUE_VIOLATION
#           RecordNotUnique.new(message, exception)
#         when FOREIGN_KEY_VIOLATION
#           InvalidForeignKey.new(message, exception)
#         else
#           super
#         end
#       end
#     end
#   end
# end

# Fixes https://github.com/rails/activerecord-session_store/issues/6
ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id

# PostgreSQL enums support (taken from https://coderwall.com/p/azi3ka)

module ActiveRecord
  module ConnectionAdapters

    class PostgreSQLAdapter
      def self.enum_types
        @enum_types ||= begin
          result = Base.connection.execute 'SELECT DISTINCT t.typname FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid'
          [].tap{ |a| result.each_row{ |v| a << v.first } }
        end
      end

      # TODO sopprimere warning (questo non funziona perché deve andare sul nome della colonna)
      # enum_types.each do |enum_type|
      #   p enum_type
      #   OID.alias_type enum_type, 'text'
      # end
    end

    class PostgreSQLColumn

      private

      def simplified_type_with_enum_types(field_type)
        if PostgreSQLAdapter.enum_types.include? field_type
          field_type.to_sym
        else
          simplified_type_without_enum_types(field_type)
        end
      end
      alias_method_chain :simplified_type, :enum_types
    end
  end
end
