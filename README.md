# Whomst

Quick and dirty Sinatra app for SNMP polling an Apple Airport Express base station to see who's online. YMMV

## Requirements

* `smnpwalk`
* `nmap` for MAC prefix database
* `dig` for Zeroconf

## Instructions

1. Make a file called `hosts` with MAC address or host in the left hand field, then a space and a free-form comment
```
DE:AD:BE:EF:12:34 Raspberry Pi 1
10.10.42.2 Raspberry Pi 1
DE:AD:BE:EF:12:34 Power Mac G4
DE:AD:BE:EF:12:34	Thinkpad x201

```
2. `bundle install`
3. Run `ruby app.rb IPADDRESS_OF_AIRPORT` and navigate to http://localhost:4567/

<table border="1">
    <tbody><tr>
      <th>host</th>
      <th>ip address</th>
      <th>mac address</th>
      <th>vendor</th>
      <th>comment</th>
      <th>zeroconf</th>
    </tr>
      <tr>
        <td valign="top" rowspan="2">raspberry pi 1</td>
      <td>10.10.32.3</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>alfa</td>
      <td> wireless</td>
        <td valign="top" rowspan="2"><pre>raspberrypi.local.</pre></td>
    </tr>
    <tr>
      <td>10.10.32.6</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>raspberry</td>
      <td> ethernet</td>
    </tr>
    <tr>
        <td valign="top" rowspan="1">melvin's macbook</td>
      <td>10.10.32.8</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>apple</td>
      <td></td>
        <td valign="top" rowspan="1"><pre>melvin.local.
"model=macbookpro3,3" "osxvers=7"</pre></td>
    </tr>
    <tr>
        <td valign="top" rowspan="1">Mac Mini</td>
      <td>10.10.32.9</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>liteon</td>
      <td></td>
        <td valign="top" rowspan="1"><pre></pre></td>
    </tr>
    <tr>
        <td valign="top" rowspan="2">Pentium PC!</td>
      <td>10.10.32.10</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>intel</td>
      <td> wireless</td>
        <td valign="top" rowspan="2"><pre>windowsxp.local.</pre></td>
    </tr>
    <tr>
      <td>10.10.32.103</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>wistron</td>
      <td> ethernet</td>
    </tr>
    <tr>
        <td valign="top" rowspan="1">jon iphone</td>
      <td>10.10.32.100</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>apple</td>
      <td></td>
        <td valign="top" rowspan="1"><pre></pre></td>
    </tr>
    <tr>
        <td valign="top" rowspan="1">tom iphone</td>
      <td>10.10.32.101</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>apple</td>
      <td></td>
        <td valign="top" rowspan="1"><pre></pre></td>
    </tr>
    <tr>
        <td valign="top" rowspan="1">tom imac</td>
      <td>10.10.32.102</td>
      <td>DE:AD:BE:EF:12:34</td>
      <td>apple</td>
      <td></td>
        <td valign="top" rowspan="1"><pre>tom-imac.local.</pre></td>
    </tr>
</tbody></table>

## Why Ruby?

This should probably be run by cron instead of running in the server.
Those slow dig calls could be parallelized with a better language.

## TODO

* [ ] Historical info (lastlog)
* [ ] Machines stick around for a long time (DHCP lifetime?)

<!--
Anonymize MAC addresses:
1,$ s/([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})/DE:AD:BE:EF:12:34/
-->
