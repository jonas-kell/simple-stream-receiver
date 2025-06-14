Might require:

<!-- xhost +local:docker -->

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

## Autostart?

You just have to edit this file
sudo nano .config/lxsession/LXDE-pi/autostart

Add this command to run a script (in this example is called shboot.sh)

@lxterminal -e /home/pi/shboot.sh

## Fresh Installation on a Raspberry Pi 3B

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install wmctrl
sudo apt-get install docker.io
sudo apt-get install docker-compose

Set the session to X11:
sudo nano /etc/lightdm/lightdm.conf

At the Part `[Seat:*]` (probably it reads `LXDE-pi-labwc`)
user-session=LXDE
autologin-session=LXDE

Save, then the command `exho $XDG_SESSION_TYPE` should produce `x11`.
And `echo $DESKTOP_SESSION` should yield `LXDE`.
