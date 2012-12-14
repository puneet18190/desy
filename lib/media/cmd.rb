require 'media_editing'
require 'subexec'

module MediaEditing
  class Cmd
    attr_reader :cmd, :subexec

    def self.subexec_options
      @subexec_options ||= {}
    end

    def run(stdout = :dev_null, stderr = :dev_null)
      stdout = %w(/dev/null w) if stdout == :dev_null
      stderr = %w(/dev/null w) if stderr == :dev_null
      @subexec = Subexec.run cmd, self.class.subexec_options.merge(stdout: stdout, stderr: stderr)
    end

    def run!(stdout = :dev_null, stderr = :dev_null)
      run(stdout, stderr)
      raise Error.new('command failed', cmd: cmd, exitstatus: exitstatus, output: subexec.output, stdout: stdout, stderr: stderr) if exitstatus != 0
    end

    def exitstatus
      subexec.try(:exitstatus)
    end

    def cmd
      @cmd ||= cmd!
    end
    alias to_s cmd

    def cmd!
      ''
    end

  end
end