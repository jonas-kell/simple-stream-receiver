Requires on Windows:

OBS

Stream:
-> stream to
rtmp://ip.ip.ip.ip:1935/live
-> Key: "stream"
-> No authentification

Output:
-> Mode advanced
-> Video Coder x264
-> Scaling deactivated
-> Quality CBR
-> Keyframe interval 0s
-> preset speed
-> CPU veryfast
-> profile high
-> tune zerolatency

On the host:
Docker installation required
Wmctrl and X11 required (see below).

-> `sudo ./run.sh` # starts everything an positions window

## Fresh Installation on a Raspberry Pi 3B

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

Set the session to X11:
sudo nano /etc/lightdm/lightdm.conf

At the Part `[Seat:*]` (probably it reads `LXDE-pi-labwc`)
user-session=LXDE
autologin-session=LXDE
autologin.user=wall # the user of the pi is called wall
autologin-user-timeout=0

Save, then the command `echo $XDG_SESSION_TYPE` should produce `x11`.
And `echo $DESKTOP_SESSION` should yield `LXDE`.
On re-log you should also immediately boot into desktop now.

Setup Autostart:
sudo apt-get install dex
mkdir -p ~/.config/autostart
nano ~/.config/autostart/stream.desktop

[Desktop Entry]
Type=Application
Name=Stream
Exec=lxterminal -e bash -c "cd /home/wall/Desktop/simple-stream-receiver/ && ./run.sh"
Path=/home/wall/Desktop/simple-stream-receiver/
X-GNOME-Autostart-enabled=true

chmod +x ~/.config/autostart/stream.desktop
dex ~/.config/autostart/stream.desktop
