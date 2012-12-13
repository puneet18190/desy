# METODO DI DEBUG
case Rails.env
when 'development', 'test'
  require 'colorize'
  def _d(*args)
    puts "#{caller.first}: #{args.map(&:inspect).join(', ')}".yellow
  end
else
  # lo dichiaro anche in produzione sia mai che mi scappa di lasciarlo nel codice
  def _d; end
end