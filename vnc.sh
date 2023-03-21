#!/bin/bash

# Remove VNC lock (if process already killed)
# rm /tmp/.X1-lock /tmp/.X11-unix/X1

# Run VNC server with tail in the foreground
# 关闭桌面 vncserver -kill :1
vncserver -localhost no :1   && tail -F /root/.vnc/*.log
