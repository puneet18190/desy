# METODO DI DEBUG
case Rails.env
when 'development', 'test'
  begin
    require 'colorize'
    def _d(*args)
      puts "#{caller.first}: #{args.map(&:inspect).join(', ')}".yellow
    end
    def _d!(*args)
      _d *args
      raise '_d!'
    end
  rescue LoadError
    def _d(*_);  end
    def _d!(*_); end
  end
else
  # lo dichiaro anche in produzione sia mai che mi scappa di lasciarlo nel codice
  def _d(*_);  end
  def _d!(*_); end
end