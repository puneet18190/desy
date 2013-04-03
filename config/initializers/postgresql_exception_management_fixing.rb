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