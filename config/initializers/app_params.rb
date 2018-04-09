$ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
$ews_url = 'https://3dwebmail.3dsystems.com/ews/Exchange.asmx'
$avail_duration = 1.months