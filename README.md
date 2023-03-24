# ros2
ros2

## vnc 桌面构建

[How to Install & Configure VNC Server on Ubuntu 22.04|20.04](
https://bytexd.com/how-to-install-configure-vnc-server-on-ubuntu/)

# Build
```shell
colcon build --symlink-install
```

# Test
```shell
colcon test
```

# 只编译某个包
```shell
colcon build --packages-select cpp_srvcli
```
