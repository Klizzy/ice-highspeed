#!/usr/bin/env sh

# ICE Highspeed Internet Data Limit Reset
# Resets the 200MB data limit by changing the MAC address.
# Supports macOS and Linux.

set -e

# --- Help ---
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: sudo $0 [INTERFACE]"
    echo ""
    echo "Resets the ICE train WiFi 200MB data limit by changing your MAC address."
    echo ""
    echo "Arguments:"
    echo "  INTERFACE   Network interface to use (e.g. en0, wlan0)."
    echo "              Auto-detected if not provided."
    echo ""
    echo "Examples:"
    echo "  sudo $0"
    echo "  sudo $0 en0"
    echo "  sudo $0 wlan0"
    exit 0
fi

# --- Root check ---
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run with root privileges."
    echo "Try: sudo $0 $*"
    exit 1
fi

# --- Detect OS ---
OS="$(uname -s)"

# --- Dependency checks ---
check_command() {
    if ! command -v "$1" > /dev/null 2>&1; then
        echo "Error: Required command '$1' not found. Please install it first."
        exit 1
    fi
}

check_command openssl

if [ "$OS" = "Darwin" ]; then
    check_command ifconfig
elif [ "$OS" = "Linux" ]; then
    if command -v ip > /dev/null 2>&1; then
        LINUX_NET_TOOL="ip"
    elif command -v ifconfig > /dev/null 2>&1; then
        LINUX_NET_TOOL="ifconfig"
    else
        echo "Error: Neither 'ip' nor 'ifconfig' found. Please install iproute2 or net-tools."
        exit 1
    fi
else
    echo "Error: Unsupported operating system '$OS'. Only macOS and Linux are supported."
    exit 1
fi

# --- Detect or use provided network interface ---
detect_interface() {
    if [ "$OS" = "Darwin" ]; then
        # macOS: find the active Wi-Fi interface via networksetup
        if command -v networksetup > /dev/null 2>&1; then
            iface=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}')
            if [ -n "$iface" ]; then
                echo "$iface"
                return
            fi
        fi
        # Fallback to en0
        echo "en0"
    else
        # Linux: find a wireless interface that is UP
        if [ -d /sys/class/net ]; then
            for dir in /sys/class/net/*/wireless; do
                if [ -d "$dir" ]; then
                    iface=$(echo "$dir" | cut -d'/' -f5)
                    echo "$iface"
                    return
                fi
            done
        fi
        # Fallback: first non-loopback interface
        if [ "$LINUX_NET_TOOL" = "ip" ]; then
            iface=$(ip -o link show | awk -F': ' '!/lo/{print $2; exit}')
        else
            iface=$(ifconfig | grep -E '^[a-z]' | head -1 | cut -d: -f1 | awk '{print $1}')
        fi
        echo "$iface"
    fi
}

IFACE="${1:-$(detect_interface)}"

if [ -z "$IFACE" ]; then
    echo "Error: Could not detect a network interface. Please provide one manually:"
    echo "  sudo $0 <interface>"
    exit 1
fi

echo "Using network interface: $IFACE"

# --- Read current MAC address ---
get_mac() {
    if [ "$OS" = "Darwin" ]; then
        ifconfig "$1" | awk '/ether/{print $2}'
    elif [ "$LINUX_NET_TOOL" = "ip" ]; then
        ip link show "$1" | awk '/link\/ether/{print $2}'
    else
        ifconfig "$1" | awk '/ether|HWaddr/{print $NF}'
    fi
}

initialMacAddress=$(get_mac "$IFACE")

if [ -z "$initialMacAddress" ]; then
    echo "Error: Could not read MAC address for interface '$IFACE'."
    echo "Make sure the interface name is correct."
    exit 1
fi

echo "Current MAC address: $initialMacAddress"

# --- Generate a new random MAC address ---
# The second character is set to '0' to ensure the unicast and locally-administered bits are valid.
newMacAddress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/./0/2; s/.$//')

echo "New MAC address:     $newMacAddress"

# --- Apply the new MAC address ---
if [ "$OS" = "Darwin" ]; then
    ifconfig "$IFACE" ether "$newMacAddress"
elif [ "$LINUX_NET_TOOL" = "ip" ]; then
    ip link set "$IFACE" down
    ip link set "$IFACE" address "$newMacAddress"
    ip link set "$IFACE" up
else
    ifconfig "$IFACE" down
    ifconfig "$IFACE" hw ether "$newMacAddress"
    ifconfig "$IFACE" up
fi

# --- Verify the change ---
currentMacAddress=$(get_mac "$IFACE")

if [ "$currentMacAddress" != "$initialMacAddress" ]; then
    echo "MAC address successfully changed!"
    echo ""
    echo "Next steps:"
    echo "  1. Wait for WiFi to reconnect (or reconnect manually)"
    echo "  2. Accept the ICE WiFi portal connection"
    echo "  3. Open login.wifionice.de to verify your new 200MB quota"
else
    echo "Error: MAC address could not be changed."
    echo ""
    echo "Troubleshooting:"
    echo "  - Make sure you are connected to the ICE WiFi"
    echo "  - Try specifying the interface manually: sudo $0 <interface>"
    echo "  - On macOS, try: sudo $0 en0"
    echo "  - On Linux, check available interfaces with: ip link show"
    exit 1
fi
