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

sudo apt install wmctrl

-> ./run.sh # starts everything and positions window

## Autostart?

You just have to edit this file
sudo nano .config/lxsession/LXDE-pi/autostart

Add this command to run a script (in this example is called shboot.sh)

@lxterminal -e /home/pi/shboot.sh


## Pi installation

sudo apt-get update
sudo apt-get upgrade
sudo apt install docker.io
sudo apt-get install docker-compose
