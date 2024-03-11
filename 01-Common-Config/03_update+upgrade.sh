#!/bin/bash

###############################################
start_time=$(date +%s)
###############################################

# apt update/upgrade
echo -e "\e[36m\n[ ansible-playbook:update+upgrade ] >>>>>>>>>>>>>>>> !!! \e[0m"
ansible-playbook command/update+upgrade.yml


###############################################
end_time=$(date +%s)  # 종료 시간 측정
execution_time=$((end_time - start_time))  # 실행 시간 계산 (초 단위)
echo "스크립트 실행 시간: $execution_time 초"
###############################################