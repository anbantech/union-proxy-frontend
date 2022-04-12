#!/bin/bash
log() {
  if [ "$1" = "WARNING" ]; then
    /bin/echo -e "\n[`date -d today +"%Y-%m-%d %H:%M:%S"`] \033[41;37m WARNING \033[0m \033[31m$2 \033[0m"
  else
    /bin/echo -e "\n[`date -d today +"%Y-%m-%d %H:%M:%S"`] \033[42;37m INFO \033[0m \033[32m$2 \033[0m"
  fi
}

GetKey() {
    section=$(echo $2 | cut -d '.' -f 1)
    key=$(echo $2 | cut -d '.' -f 2)
    sed -n "/\[$section\]/,/\[.*\]/{
     /^\[.*\]/d
     /^[ \t]*$/d
     /^$/d
     /^#.*$/d
     s/^[ \t]*$key[ \t]*=[ \t]*\(.*\)[ \t]*/\1/p
    }" $1
}

# global
fe_port=$(GetKey "data.ini" "global.fe_port")
fe_image=$(GetKey "data.ini" "global.fe_image")
fe_tag=$(GetKey "data.ini" "global.fe_tag")
fe_container=$(GetKey "data.ini" "global.fe_container")
config_file=config.json
local_area_network=`ifconfig | grep 192 | awk '{print $2}'`

# products
yh_name=$(GetKey "data.ini" "yh.name")
yh_desc=$(GetKey "data.ini" "yh.desc")
yh_link=$(GetKey "data.ini" "yh.link")
yc_name=$(GetKey "data.ini" "yc.name")
yc_desc=$(GetKey "data.ini" "yc.desc")
yc_link=$(GetKey "data.ini" "yc.link")
ys_name=$(GetKey "data.ini" "ys.name")
ys_desc=$(GetKey "data.ini" "ys.desc")
ys_link=$(GetKey "data.ini" "ys.link")
yz_name=$(GetKey "data.ini" "yz.name")
yz_desc=$(GetKey "data.ini" "yz.desc")
yz_link=$(GetKey "data.ini" "yz.link")
yj_name=$(GetKey "data.ini" "yj.name")
yj_desc=$(GetKey "data.ini" "yj.desc")
yj_link=$(GetKey "data.ini" "yj.link")
yxiang_name=$(GetKey "data.ini" "yxiang.name")
yxiang_desc=$(GetKey "data.ini" "yxiang.desc")
yxiang_link=$(GetKey "data.ini" "yxiang.link")
sca_name=$(GetKey "data.ini" "sca.name")
sca_desc=$(GetKey "data.ini" "sca.desc")
sca_link=$(GetKey "data.ini" "sca.link")

usage() {
    /bin/echo -e "\nUsage: sh deploy.sh [OPTIONS]\n"
    /bin/echo -e "Options:"
    /bin/echo -e "\tinstall:      install union-proxy"
    /bin/echo -e "\tuninstall:    uninstall union-proxy"
    /bin/echo -e "\tstatus:       check union-proxy status"
    /bin/echo -e "\033[1m\nTo get more help with union-proxy, please @AnbanTech."
}

check() {
    pid=`docker ps | grep $fe_container-$fe_tag`
    if [ "$pid" = "" ]; then
        log "WARNING" "union-proxy is not running!\n"
    else
        log "INFO" "$pid"
        log "INFO" "union-proxy is running at http://$local_area_network:$fe_port/\n"
    fi
}

generateConfigFile() {
    echo "{
    \"data\": [
        {
            \"name\": \"$yh_name\",
            \"desc\": \"$yh_desc\",
            \"link\": \"$yh_link\",
            \"disable\": false
        },
        {
            \"name\": \"$yc_name\",
            \"desc\": \"$yc_desc\",
            \"link\": \"$yc_link\",
            \"disable\": false
        },
        {
            \"name\": \"$ys_name\",
            \"desc\": \"$ys_desc\",
            \"link\": \"$ys_link\",
            \"disable\": false
        },
        {
            \"name\": \"$yz_name\",
            \"desc\": \"$yz_desc\",
            \"link\": \"$yz_link\",
            \"disable\": false
        },
        {
            \"name\": \"$yj_name\",
            \"desc\": \"$yj_desc\",
            \"link\": \"$yj_link\",
            \"disable\": false
        },
        {
            \"name\": \"$yxiang_name\",
            \"desc\": \"$yxiang_desc\",
            \"link\": \"$yxiang_link\",
            \"disable\": false
        },
        {
            \"name\": \"$sca_name\",
            \"desc\": \"$sca_desc\",
            \"link\": \"$sca_link\",
            \"disable\": false
        }
    ]
}" > $config_file
}

if [ $# -eq 1 ]; then
    case "$1" in
        "install")
            log "INFO" "start to install union-proxy!"

            log "INFO" "generate $config_file from data.ini"

            generateConfigFile

            log "INFO" "file generated in $PWD/$config_file"

            log "INFO" "load docker image"

            find $fe_image-$fe_tag.tar

            if [ $? -ne 0 ]; then
                log "WARNING" "can not find a image named $fe_image-$fe_tag.tar, be sure to copy it into this dir!!!"
                exit 1
            fi

            docker load < $fe_image-$fe_tag.tar

            if [ $? -ne 0 ]; then
                log "WARNING" "$fe_image-$fe_tag.tar is not a docker image, be sure to copy the correct image tar!!!"
                log "WARNING" "or maker sure the docker service is online!!!"
                exit 1
            fi

            log "INFO" "start the container"

            docker run -d -p $fe_port:80 --name $fe_container-$fe_tag --restart always $fe_image:$fe_tag
            docker cp $config_file $fe_container-$fe_tag:/usr/share/nginx/html/
            docker restart $fe_container-$fe_tag

            log "INFO" "deploy finished, checking system!!!"

            sleep 3s

            check
        ;;
        "uninstall")
            log "INFO" "start to uninstall union-proxy!"

            docker stop $fe_container-$fe_tag && docker rm $fe_container-$fe_tag

            if [ $? -ne 0 ]; then
                log "WARNING" "$fe_container-$fe_tag is not a running container, union-proxy is may not installed"
                log "WARNING" "or maker sure the docker service is online!!!"
            fi

            log "INFO" "remove $PWD/$config_file"

            rm $PWD/$config_file

            if [ $? -ne 0 ]; then
                log "WARNING" "$PWD/$config_file is not a existed, skipping..."
            else
                log "INFO" "remove union-proxy successfully, you can re-install by using [sh ./deploy.sh install]"
            fi

            log "INFO" "checking system!!!"

            sleep 3s

            check
        ;;
        "status")
           check
        ;;
        *)
            usage
        ;;
    esac
else
    usage
fi
