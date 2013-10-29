# Module containing helpers for mailer
module MailerHelper
  
  # Adds the host and a port to values to be passed to an +url_for+ method
  def host_and_port(*url_for_args)
    return url_for_args unless @host
    host_port = { host: @host }
    host_port[:port] = @port if @port != 80
    last = url_for_args.last
    if last.instance_of? Hash
      url_for_args[0, url_for_args.size - 1] + [last.merge(host_port)]
    else
      url_for_args + [host_port]
    end
  end
  
end
