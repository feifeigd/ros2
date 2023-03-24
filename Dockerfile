FROM ubuntu:22.04

LABEL author=feifeigd

# 阿里云 源 
# COPY 163 /etc/apt/sources.list 
# Install LXDE,VNC server, XRDP and Firefox
COPY ros.key /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" |  tee /etc/apt/sources.list.d/ros2.list > /dev/null

# 安装中文字体
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y aptitude \
    fonts-wqy-zenhei language-pack-zh-hans locales software-properties-common

RUN locale-gen zh_CN.UTF-8 && update-locale LC_ALL=zh_CN.UTF-8 LANG=zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
# 下面就有中文了
RUN add-apt-repository universe && apt update && apt upgrade

RUN apt install -y --fix-missing tigervnc-standalone-server

RUN DEBIAN_FRONTEND=noninteractive apt install -y --fix-missing xfce4
RUN DEBIAN_FRONTEND=noninteractive apt install -y --fix-missing xfce4-goodies

# 安装 ros 环境
RUN DEBIAN_FRONTEND=noninteractive aptitude install -y ros-humble-ros-base
RUN aptitude install -y vim ros-dev-tools
RUN apt install -y --fix-missing ~nros-humble-rqt*
RUN DEBIAN_FRONTEND=noninteractive aptitude install -y ros-humble-desktop

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

RUN echo ". /opt/ros/humble/setup.bash" >> ~/.bashrc
# RUN . ~/.bashrc && ros2 -h

# Setup colcon_cd
RUN echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc
RUN echo "export _colcon_cd_root=/opt/ros/humble/" >> ~/.bashrc
# Setup colcon tab completion
RUN echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc
   

CMD [ "/opt/vnc.sh" ]
# CMD [ "bash" ]
# docker image build -t ros2 .
# docker run --rm -p 5901:5901 ros2
# open vnc://localhost:5901
# 登陆之后，设置默认终端
# Applications -> Settings -> Default Applications -> Utilities 终端模拟器，选择 Xfce Terminal
