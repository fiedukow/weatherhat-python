#!/bin/bash

mkdir -p  ~/.config/pip/
echo "[global]" > ~/.config/pip/pip.conf
echo "break-system-packages = true" >> ~/.config/pip/pip.conf

sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_spi 0

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get -y install git python3-pip vim

git clone https://github.com/pimoroni/weatherhat-python
cd weatherhat-python
yes | ./install.sh --unstable

pip3 install fonts font-manrope pyyaml adafruit-io numpy
sudo apt-get -y install libatlas-base-dev

cd ..

# Append yourself to the end of /etc/rc.local
file_name="/etc/rc.local"
new_line="sudo -u weather screen -d -m python3 /home/weather/weatherhat-python/examples/weather.py"
before_line="exit 0"

# Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File $file_name does not exist."
    exit 1
fi

# Use awk to add the new line before the specific line, ignoring leading and trailing spaces
awk -v new_line="$new_line" -v before_line="$before_line" '
    function trim(str) {
        gsub(/^[ \t]+|[ \t]+$/, "", str)
        return str
    }
    trim($0) == before_line {
        print new_line
    }
    { print }
' "$file_name" > modified_rc.local && sudo mv modified_rc.local "$file_name"


# Reboot

sudo reboot