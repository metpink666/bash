#!/bin/bash

while true; do
    clear
    echo "————————————————————————————————————————————"
    echo "       泠 の V2bX - lxc - debian 专用       "
    echo "————————————————————————————————————————————"
    echo "             [1]:  检测运行状态             "
    echo "             [2]:  启动                     "
    echo "             [9]:  退出                     "
    echo "————————————————————————————————————————————"
    echo -n "       请选择:"
    read choice
    
    if [ "$choice" = "1" ]; then
        clear
        echo "状态:"
        ps aux | grep V2bX
        echo "————————————————————————————————————————————"
        echo "按回车键返回菜单..."
        read
    elif [ "$choice" = "2" ]; then
        clear
        pkill -f "V2bX server" 2>/dev/null
        cd /usr/local/V2bX || exit
        nohup ./V2bX server -w=false >/dev/null 2>&1 &
        echo "V2bX 已成功运行于 $(date)"
        echo "————————————————————————————————————————————"
        echo "按回车键返回菜单..."
        read
    elif [ "$choice" = "9" ]; then
        clear
        break
    fi
done
