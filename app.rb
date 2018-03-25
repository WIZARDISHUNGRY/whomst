require 'sinatra'
require './snmp'
host = ARGV[0]
unless host
  puts "specify host on commandline"
  exit
end
get '/' do
  data = Snmp.new(host).get
  erb :home, :locals => {:data => data}
end
