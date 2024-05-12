#!/bin/bash

echo ">>>> Configuring Kernel <<<<"
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_spi 0

echo ">>>> Upgrading raspberry pi os <<<<"
sudo apt-get update -y
sudo apt-get upgrade -y

echo ">>>> Installing basic environment <<<<"
sudo apt-get -y install git python3-pip vim libopenblas-dev python3-rpi-lgpio libopenjp2-7 screen

echo ">>>> Configuring PIP <<<<"
mkdir -p  ~/.config/pip/
echo "[global]" > ~/.config/pip/pip.conf
echo "break-system-packages = true" >> ~/.config/pip/pip.conf

echo ">>>> Installing Weather HAT software <<<<"
git clone https://github.com/fiedukow/weatherhat-python
cd weatherhat-python
./install.sh --unstable --force

echo ">>>> Installing Weather HAT extra dependencies <<<<"
pip3 install fonts font-manrope pyyaml adafruit-io numpy pillow
sudo apt-get -y install libatlas-base-dev

cd ..

echo ">>>> Setting up rc.local <<<<"

# Append yourself to the end of /etc/rc.local
file_name="/etc/rc.local"
new_line="cd /home/weather/ && sudo -u weather screen -d -m python3 /home/weather/weatherhat-python/examples/weather.py"
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
' "$file_name" > modified_rc.local && sudo cp --no-preserve=mode,ownership modified_rc.local "$file_name" && rm modified_rc.local

# Reboot
echo ">>>> Setup is ready. Now rebooting... <<<<"
sudo reboot
