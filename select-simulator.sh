#!/bin/sh

docker pull devrt/simulator-index

# 生成新的 docker-compose.yml
docker run -it --rm -v `pwd`:/work devrt/simulator-index
