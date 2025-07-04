# Simple Stream Receiver

Used to stream a single application window from a Windows PC to a Raspberry Pi over LAN and display it in the top left corner of the screen.

## Installation on the Client (Windows PC)

Requires [OBS](https://obsproject.com/) to be installed.

Configure the source application detection, canvas size and scene properties to your liking.
(Best to turn off sound, set the canvas size to the desired size to avoid rescaling, set the application detection to test only for the title - that way it re-discovers the window on closing.)

### Specific settings in OBS

Stream:

-   Stream to: `srt://ip.ip.ip.ip:8888?mode=caller&latency=10` (replace with the target IP)
    -   Filled in for the static IP that is used later: `srt://192.168.150.150:8888?mode=caller&latency=10`
-   Key: `""` (leave empty)
-   No authentification

Output:

-   Mode advanced
-   Video Coder x264
-   Scaling deactivated
-   Quality CBR
-   Keyframe interval 0s
-   preset speed
-   CPU veryfast
-   profile high
-   tune zerolatency

## Installation of the Server (Linux)

Generally, to run this you require an installation of [Docker](https://www.docker.com/) with [Docker compose](https://docs.docker.com/compose/).
Furthermore, you need [Wmctrl](https://wiki.ubuntuusers.de/wmctrl/) and the window system should be X11.

In the case of this all being available, you only need to run the following command inside the main folder of this repository.

```cmd
sudo ./run.sh
```

### Fresh Installation on a Raspberry Pi 3B

Starting with a blank Raspberry Pi 3B and flashing the default `Buster` image with desktop with the use of [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
In this case, the user that is used in installation is called `wall` (as we use this for a local video wall).

Upgrade the installation and install docker:

```cmd
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install wmctrl
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker
sudo systemctl start docker
mkdir -p ~/.docker/cli-plugins/
ARCH=$(uname -m)
curl -SL https://github.com/docker/compose/releases/download/v2.36.2/docker-compose-linux-$ARCH -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
```

Set the session to X11 and make the user auto-login on boot:

```cmd
sudo nano /etc/lightdm/lightdm.conf
```

Modify the config file that opens.
At the Part `[Seat:*]` (probably it reads `LXDE-pi-labwc`) replace with the following settings

```config
user-session=LXDE
autologin-session=LXDE
autologin.user=wall # the user of the pi is called wall
autologin-user-timeout=0
```

Save, then the command `echo $XDG_SESSION_TYPE` should produce `x11`.
And `echo $DESKTOP_SESSION` should yield `LXDE`.
On re-log you should also immediately boot into desktop now.

Setup the program to auto-start:

```cmd
sudo apt-get install dex
mkdir -p ~/.config/autostart
nano ~/.config/autostart/stream.desktop
```

Fill the new file with the following configuration (this assumes, that the repo was cloned to `home/wall/Desktop/simple-stream-receiver`).

```config
[Desktop Entry]
Type=Application
Name=Stream
Exec=lxterminal -e bash -c "cd /home/wall/Desktop/simple-stream-receiver/ && ./run.sh"
Path=/home/wall/Desktop/simple-stream-receiver/
X-GNOME-Autostart-enabled=true
```

Save and run the following commands to activate

```cmd
chmod +x ~/.config/autostart/stream.desktop
dex ~/.config/autostart/stream.desktop
```

Setup a static IP:

The following command shows the name of the wired connection (use any other interface you want to target).
We assume, that the system uses `NetworkManager`.
Caution, you probably lose internet access after this, if your network can't handle the newly static assigned IP/Subnet.

```cmd
nmcli connection # find the name of the ethernet interface (later, name is already filled in as "Wired connection 1")
```

Modify the connection (Here the IP is pre-filled with `192.168.150.150`, replace with your IP if needed):

```cmd
nmcli connection modify "Wired connection 1" \
 ipv4.addresses 192.168.150.150/24 \
 ipv4.gateway 192.168.150.10 \
 ipv4.dns "8.8.8.8 1.1.1.1" \
 ipv4.method manual

sudo systemctl restart NetworkManager
nmcli connection down "Wired connection 1" && nmcli connection up "Wired connection 1"
```

Now running `ifconfig` whould show that the main network connection has a static IP set up.

Make the networking delay on boot (as otherwise the switch is not yet ready...):

```cmd
sudo mkdir -p /etc/systemd/system/NetworkManager.service.d
sudo nano /etc/systemd/system/NetworkManager.service.d/delay.conf
```

Fill the newly opened config with the following;

```config
[Service]
ExecStartPre=/bin/sleep 30
```

And run the remaining commands to enable the changes and trigger a reboot to test everything:

```cmd
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo reboot
```

<!-- Disable `systemd-networkd` (as we use `NetworkManager`).
sudo systemctl disable --now systemd-networkd.socket
sudo systemctl disable --now systemd-networkd
-->
