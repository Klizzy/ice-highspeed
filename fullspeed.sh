#!/usr/bin/env sh

initialMacAddress=$(ifconfig en0 |grep ether | cut -c 7-)
newMacAdress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/./0/2; s/.$//')
sudo ifconfig en0 ether ${newMacAdress}

currentMacAddress=$(ifconfig en0 |grep ether | cut -c 7-)

if [[ ${currentMacAddress} != ${initialMacAddress} ]]; then
    echo "Mac Address Successfully changed from ${initialMacAddress} to: ${newMacAdress}"
else
	echo "Mac Address could not be changed!"
fi