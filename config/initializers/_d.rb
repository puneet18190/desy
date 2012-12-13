# METODO DI DEBUG
case Rails.env
when 'development', 'test'
  require 'colorize'
  def _d(*args)
    puts "#{caller.first}: #{args.map(&:inspect).join(', ')}"
  end
else
  def _d; end
end