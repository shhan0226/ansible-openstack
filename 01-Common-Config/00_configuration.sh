#!/bin/bash

###############################################
start_time=$(date +%s)
###############################################

# cp sample file
echo -e "\e[36m\n[ insert inventory/hosts ] >>>>>>>>>>>>>>>> !!! \e[0m"

if [ -f "../inventory/hosts.sample" ]; then
  echo "Set inventory"
  cp ../inventory/hosts.sample ../inventory/hosts

  ##############################################################################
  ##############################################################################
  # remote server ID 
  USER_="user"  
  # remote server pw (user, ubuntu)
  PASSWD_="user"  
  # remote server IP 
  # REMOTES_IP_=("192.168.0.41" "192.168.0.42" "192.168.0.43")
  # /inventory/hosts의 [workers]아래 hostname을 추가해 주세요!!
  # 공백은 " " 입니다.!!1
  REMOTES_IP_=("192.168.3.141" "192.168.3.142" )
  # HOSTNAME 입력, IP의 갯수와 같아야 한다.
  HOST_NAME=("controller" "compute1")
  # OpenStack Version: yoga
  OPENSTACK_VER_="yoga"
  # interface of Node (enp1s0/eth0)
  INTERFACE_NAME_v="eth0"
  # OpenStack Allow Networks
  SET_IP_ALLOWv="192.168.0.0/22"
  # OpenStack passwd
  STACK_PASSWDv="stack"  
  ##############################################################################
  ##############################################################################
  
fi

# apt
echo " !!! [apt... ] !!! "
sudo apt install ansible -y
sudo apt install sshpass -y

# ssh
echo " !!! [create ssh keygen...] !!! "
rm $HOME/.ssh/id_rsa
ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa

export USER=$USER_
sed -i'' "s/USER_SET/$USER/" ../inventory/hosts

export PASSWD=$PASSWD_
sed -i'' "s/PASSWD_SET/$PASSWD/" ../inventory/hosts

# echo " !!! [send ssh keygen...] !!! "
# for ip in "${REMOTES_IP_[@]}"; do
#     echo "현재 IP 주소는 $ip 입니다."
#     ssh-keygen -f "$HOME/.ssh/known_hosts" -R $ip
#     sshpass -p $PASSWD ssh-copy-id -o StrictHostKeyChecking=no $USER@$ip
#     sed -i "/\[remotes\]/a $ip hostname\=" ../inventory/hosts
#     #crudini --set ./inventory/hosts remotes $ip
# done

# REMOTES_IP_와 HOST_NAME의 길이를 비교합니다.
if [ ${#REMOTES_IP_[@]} -eq ${#HOST_NAME[@]} ]; then
    LENGTH=${#REMOTES_IP_[@]}

    # SSH 처리
    for (( i=0; i<$LENGTH; i++ )); do
        ip=${REMOTES_IP_[$i]}
        echo "SSH 처리 중: 현재 IP 주소는 $ip 입니다."
        ssh-keygen -f "$HOME/.ssh/known_hosts" -R $ip
        sshpass -p $PASSWD ssh-copy-id -o StrictHostKeyChecking=no $USER@$ip
    done
    
    #inventory/hosts 파일에 입력
    for (( i=0; i<$LENGTH; i++ )); do
        ip=${REMOTES_IP_[$i]}
        hostname=${HOST_NAME[$i]}
        echo "inventory/hosts 파일에 입력 중: $ip hostname=$hostname"
        # sed 명령을 사용하여 inventory/hosts 파일에 호스트 이름을 추가합니다.
        sed -i "/\[remotes\]/a $ip hostname=$hostname" ../inventory/hosts
    done
else
    echo " "
    echo -e "################################################"
    echo "REMOTES_IP_와 HOST_NAME 배열의 길이가 다릅니다.#"
    echo "스크립트를 종료합니다...                       #"
    echo -e "################################################"
    trap 'echo "..."; exit' EXIT
fi


sed -i'' "s/OPENSTACK_VERv/$OPENSTACK_VER_/" ../inventory/hosts


export INTERFACE_NAME_=$INTERFACE_NAME_v
sed -i'' "s/INTERFACE_NAME_v/$INTERFACE_NAME_/" ../inventory/hosts


export SET_IP_ALLOW=$SET_IP_ALLOWv
sed -i "s@SET_IP_ALLOWv@${SET_IP_ALLOW}@g" ../inventory/hosts


export STACK_PASSWD=$STACK_PASSWDv
sed -i'' "s/STACK_PASSWDv/$STACK_PASSWD/" ../inventory/hosts


echo -e "\e[36m\n[ The END... ] !!! \e[0m"
###############################################
end_time=$(date +%s)  # 종료 시간 측정
execution_time=$((end_time - start_time))  # 실행 시간 계산 (초 단위)
echo "스크립트 실행 시간: $execution_time 초"
###############################################

# echo -e " "
# echo -e " "
# echo -e "################################################################"
# echo -e "## ../inventory/hosts의 [remote]아래, hostname을 추가해 주세요!#"
# echo -e "## ex) controller, compute1, compute2 ...                      #"
# echo -e "################################################################"
# echo -e " "
# echo -e " "