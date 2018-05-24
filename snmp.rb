require 'pry'
require 'ipaddr'

class Snmp
  def string
    # 'iso.3.6.1.4.1.63.501.3.3.2.1'
    'iso.3.6.1.4.1.63.501.3.3.2.1'
  end
  def initialize(host)
    @host = host
  end
  def get
    data = {}
    `snmpwalk -v 2c -c public -Os #{@host} #{string}`.lines.map(&:chomp).each do |line|
      # enterprises.63.501.3.3.2.1.1.17.48.48.58.53.54.58.67.68.58.65.54.58.53.57.58.52.65 = STRING: "00:56:CD:A6:59:4A"
      parts = line.split ' = '
      key = parts[0].match /\.\d*\.\d*\.\d*\.\d*$/
      next unless parts[1]
      value = (parts[1].match /: \"?([^"]*)\"?$/).to_a.fetch 1, ''
      dict = data.fetch key.to_s, []
      dict.push value.to_s
      data[key.to_s] = dict
      puts "@@ #{key } #{value}  -- #{line}"
    end
    data = data.values.map do |dict|
      [
        :mac,
        :ip,
        :dhcp,
        :what
      ].zip(dict).to_h
    end
    grouped = {}
    data.map do |d|
      d[:vendor] = mac_lookup d[:mac]
      key = host_lookup(d[:mac]) || host_lookup(d[:ip]) || host_lookup(d[:dhcp]) || d[:ip] || ''
      parts = key.split ' #',2
      key = parts[0]
      comment = parts[1] || ''
      d[:comment] = comment
      d[:up] = false
      if d[:ip] && !d[:ip].empty?
        d[:up] = ping d[:ip]
      else
        d[:ip] = nil
      end

      hosts = grouped.fetch key, []
      hosts.push d
      grouped[key] = hosts
    end
    grouped = grouped.sort_by do |key,nodes|
      (nodes.map { |node| (node[:ip] ? (IPAddr.new node[:ip]) : 0).to_i }).sort.first
    end
    grouped.each do |key,nodes|
      node = nodes.first
      node[:zeroconf] = zeroconf_lookup node[:ip]
    end
  end

  def ping(addr)
    return false unless addr
    addr = (IPAddr.new addr).to_s # sanity check
    system "ping -c 10 -i 0.1 -t 1 -o #{addr}"
  end

  def zeroconf_lookup(addr)
    return '' unless addr
    addr = (IPAddr.new addr).to_s # sanity check
    out = `dig +time=1 +noall +additional +answer -x #{addr} @224.0.0.251 -p 5353`.lines.map(&:chomp).map do |line|
      (line.split "\t").last
    end
    out = out.join "\n"
    return "" if out.match /^;/
    out
  end

  def host_lookup(addr)
    unless @hosts
      @hosts = {}
      (File.readlines './hosts').map(&:chomp).each do |line|
        next if line.chars[0] == '#'
        parts = line.split ' ',2
        @hosts[parts[0]] = parts[1]
      end
    end
    return @hosts.fetch addr, nil
  end

  def mac_lookup(addr)
    addr = addr.gsub ':',''
    addr = addr.chars.slice(0,6).join
    unless @macs
      @macs = {}
      (File.readlines '/usr/local/share/nmap/nmap-mac-prefixes').map(&:chomp).each do |line|
        next if line.chars[0] == '#'
        parts = line.split ' '
        @macs[parts[0]] = parts[1]
      end
    end
    return @macs.fetch addr, ''
  end

end
