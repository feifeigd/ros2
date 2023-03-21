FROM ubuntu:22.04

LABEL author=feifeigd

# 阿里云 源 
# COPY 163 /etc/apt/sources.list 
# Install LXDE,VNC server, XRDP and Firefox
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y aptitude 
RUN DEBIAN_FRONTEND=noninteractive aptitude install -y firefox tigervnc-standalone-server

RUN DEBIAN_FRONTEND=noninteractive aptitude install -y  xfce4   
RUN DEBIAN_FRONTEND=noninteractive aptitude install -y     xfce4-goodies

# Set user for VNC server (USER is only for build)
ENV USER root
# Set default password
COPY password.txt .
RUN cat password.txt password.txt | vncpasswd && rm password.txt
# Expose VNC port
EXPOSE 5901

# Copy VNC script that handles restarts
COPY xstartup ~/.vnc/
COPY vnc.sh /opt/
CMD [ "/opt/vnc.sh" ]
# CMD [ "bash" ]
# docker image build -t ros2 .
# docker run --rm -p 5901:5901 ros2
