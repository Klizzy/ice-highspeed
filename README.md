# ICE highspeed internet data limit reset

This script resets the 200MB data limit for the highspeed internet on ICE trains in Germany.
It works by changing the MAC address of your network interface, so you will need admin/root rights to run it.

Keep in mind that your old MAC address will still be shown in your network settings.

**Tested on macOS and Linux.**

If you like this script, consider giving this project a :star: on GitHub.

### DE

Dieses Skript kann das 200MB-Datenlimit / Datenvolumen fuer das Highspeed-Internet in ICE-Zuegen in Deutschland zuruecksetzen. Es aendert im Grunde nur die MAC-Adresse des Rechners, deswegen werden Administratorrechte benoetigt, um dieses Skript auszufuehren.

Bitte beachten, dass selbst nach der Ausfuehrung des Scripts die alte MAC-Adresse weiterhin in den Netzwerkeinstellungen angezeigt wird.

**Es wurde unter macOS und Linux getestet.**

Zeige deinen Support, indem du diesem Projekt ein :star: auf GitHub gibst.

## Demo video
- <a href="https://vimeo.com/621098282" target="_blank">Showcase - how to reset the 200MB data limit</a>

## Usage

> Admin/root rights are required to execute this script.

### Quick execution

Run the script directly from your terminal — no need to clone the repo:

```sh
curl -sL https://raw.githubusercontent.com/Klizzy/ice-highspeed/master/fullspeed.sh | sudo sh
```

You can also pass a specific network interface:

```sh
curl -sL https://raw.githubusercontent.com/Klizzy/ice-highspeed/master/fullspeed.sh | sudo sh -s -- wlan0
```

> Continue with step `3` below.

### Saving and executing the script locally

1. Open a terminal and clone the repo:
```sh
git clone https://github.com/Klizzy/ice-highspeed.git
cd ice-highspeed
```

2. Run the script (the interface is auto-detected, or pass it manually):
```sh
sudo sh fullspeed.sh
# or with a specific interface:
sudo sh fullspeed.sh wlan0
```

3. Wait for the WiFi to reconnect
4. Confirm the new connection to the ICE WiFi
5. Open login.wifionice.de in a new browser window to see your refreshed 200MB quota

### Troubleshooting

If you can't reset your data limit with the steps above:

1. Disconnect from the ICE WiFi manually
2. Run the script
3. Disable and re-enable WiFi
4. Reconnect to the ICE WiFi

### Help

```sh
sh fullspeed.sh --help
```
