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
