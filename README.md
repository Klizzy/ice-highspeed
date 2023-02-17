# ICE highspeed Internet restore

This script can reset the 200MB data limit for the highspeed internet on ICE trains in Germany.
It basically just changes the MAC address for your machine, so you will need admin rights to run this script.

Keep in mind, that your old MAC address will still be shown in your network settings. 

**It was only tested on MacOS / Linux!**

If you like this script, consider to give this project a :star: on GitHub to show support.

### DE

Dieses Skript kann das 200MB-Datenlimit / Datenvolumen für das Highspeed-Internet in ICE-Zügen in Deutschland zurücksetzen. Es ändert im Grunde nur die MAC-Adresse des Rechners, deswegen werden Administratorrechte benötigt, um dieses Skript auszuführen.

Bitte beachten, dass selbst nach der Ausführung des Scripts die alte MAC-Adresse weiterhin in den Netzwerkeinstellungen angezeigt wird.

**Es wurde nur unter MacOS / Linux getestet!**

Zeige deinen Support, indem du diesem Projekt ein :star: auf GitHub gibst.

## Demo video 
- https://vimeo.com/621098282

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
3. disable and enable wifi
4. connect to ICE wifi
