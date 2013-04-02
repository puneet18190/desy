require 'media'
require 'subexec'

module Media
  class Cmd
    class_attribute :subexec_options
    self.subexec_options = {}
    
    attr_reader :cmd, :subexec

    def run(stdout = :dev_null, stderr = :dev_null)
      stdout = %w(/dev/null w) if stdout == :dev_null
      stderr = %w(/dev/null w) if stderr == :dev_null

      File.write(stdout[0], "#{cmd}\n\n") if stdout.is_a?(Array) && stdout[1] == 'a'

      @subexec = Subexec.run cmd, subexec_options.merge(stdout: stdout, stderr: stderr)
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