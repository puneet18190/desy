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