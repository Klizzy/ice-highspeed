# ICE highspeed Internet restore

This script can reset the 200MB data limit for the highspeed internet on ICE trains in Germany.
It basically just changes the MAC address for your machine, so you will need admin rights to run this script.

Keep in mind, that your old mac address will still be shown in your network settings. 

**It only works on MacOS / Linux!**

Demo: https://streamable.com/wnj4f

## Usage

1. open terminal and clone the repo
```
git clone https://github.com/Klizzy/ice-highspeed.git .
```

2. run the script (admin password will be needed)
```
sh fullspeed.sh
```

3. wait for the wifi to reconnect
4. confirm the new connection to the ICE wifi
5. open login.wifionice.de in a new browser window to see that you have 200MB highspeed internet again

If you can't reset your data limit with the steps above, try this one:

1. disconnect from the ICE wifi manually
2. run the script
3. disable and reenable wifi
4. connect to ICE wifi
