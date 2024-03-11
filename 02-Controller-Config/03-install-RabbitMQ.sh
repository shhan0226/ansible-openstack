#!/bin/bash

start_time=$(date +%s)
#######################################################

# install docker
echo -e "\e[36m\n[ ansible-playbook:install-RabbitMQ ] >>>>>>>>>>>>>>>> !!! \e[0m"
ansible-playbook command/install-RabbitMQ.yml


#######################################################
sync
end_time=$(date +%s)  # 종료 시간 측정
execution_time=$((end_time - start_time))  # 실행 시간 계산 (초 단위)

echo "스크립트 실행 시간: $execution_time 초"
