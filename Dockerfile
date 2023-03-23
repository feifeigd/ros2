FROM ubuntu:22.04

LABEL author=feifeigd

# 阿里云 源 
# COPY 163 /etc/apt/sources.list 
# Install LXDE,VNC server, XRDP and Firefox
RUN apt update && apt install -y aptitude
RUN apt install -y tigervnc-standalone-server

RUN DEBIAN_FRONTEND=noninteractive apt install -y --fix-missing  xfce4 xfce4-goodies

RUN DEBIAN_FRONTEND=noninteractive aptitude install -y software-properties-common && add-apt-repository universe
# RUN DEBIAN_FRONTEND=noninteractive aptitude install -y gnome-session gnome-terminal

# 安装 ros 环境
COPY ros.key /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" |  tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update && apt upgrade
RUN DEBIAN_FRONTEND=noninteractive aptitude install -y -o APT::Get::Fix-Missing=true ros-humble-desktop
RUN aptitude install -y vim ros-dev-tools && echo ". /opt/ros/humble/setup.sh" >> ~/.bashrc
RUN aptitude install -y -o APT::Get::Fix-Missing=true ~nros-humble-rqt*

RUN apt install -y curl wget

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
# open vnc://localhost:5901
# 登陆之后，设置默认终端
# Applications -> Settings -> Default Applications -> Utilities 终端模拟器，选择 Xfce Terminal
