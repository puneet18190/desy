require 'dumpable'
require 'controller_info'

# Patch to Arel::Nodes:SqlLiteral which permits to dump it using Psych
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