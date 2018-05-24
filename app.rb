require 'sinatra'
require './snmp'
require 'logger'

host = ARGV[0]
unless host
  puts "specify host on commandline"
  exit
end
configure do
  set :logging, Logger::DEBUG
end
set :bind, '0.0.0.0'
get '/' do
  data = Snmp.new(host).get
  erb :home, :locals => {:data => data}
end
