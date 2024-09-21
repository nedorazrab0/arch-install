#!/usr/bin/env bash
set -e
read -p '- Press [Enter] '

# net tweaks
sysctl -w 'net.ipv4.tcp_fastopen = 3'
sysctl -w 'net.core.somaxconn = 8192'
sysctl -w 'net.ipv4.tcp_timestamps = 0'
sysctl -w 'net.ipv4.tcp_ecn = 1'
sysctl -w 'net.ipv4.tcp_congestion_control = bbr'

# ntp
sed -i -e 's/#NTP=/NTP=/' -e 's/#FallbackNTP=.*/FallbackNTP=time.google.com/' /etc/systemd/timesyncd.conf
systemctl restart systemd-timesyncd

path='/tmp/njk'
# pacman configuration
sed -i -e 's/#ParallelDownloads/ParallelDownloads/' -e 's/#Color/Color/' -e 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
echo '- Configurating mirrors...'
systemctl restart reflector
pacman -Syy archlinux-keyring git --needed --noconfirm
rm -rf "$path"
git clone https://github.com/nedorazrab0/arch-install.git "$path"

source "$path/main.sh"
