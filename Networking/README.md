#General Networking Snippits

##MAC Address
####Retrieve MAC Address
```Bash
ifconfig en0 | grep ether | awk '{ print $2 }'
```

####Set Specific MAC Address
```Bash
sudo ifconfig en0 ether aa:bb:cc:dd:ee:ff
```

####Generate Random MAC Address
```Bash
openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether
```

##DNS
####Flush DNS Cache
```Bash
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder;
```