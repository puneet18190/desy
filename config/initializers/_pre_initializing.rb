module EasyMarshalDumpableHash
  def self.easy_marshal_dumpable_hash(hash)
    Hash[ hash.map do |k, v|
      [ k,
        if v.is_a?(Hash)
          easy_marshal_dumpable_hash(v)
        else
          begin
            Marshal.dump(v)
            v
          rescue TypeError
            v.inspect
          end
        end ]
    end ]
  end
end

class ControllerInfo
  attr_reader :controller_name, :action_name

  def initialize(controller_name, action_name)
    @controller_name, @action_name = controller_name, action_name
  end
end
