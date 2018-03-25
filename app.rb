require 'sinatra'
require './snmp'
host = ARGV[0]
unless host
  puts "specify host on commandline"
  exit
end
set :bind, '0.0.0.0'
get '/' do
  data = Snmp.new(host).get
  erb :home, :locals => {:data => data}
end
