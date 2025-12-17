#!/bin/bash
# V2bX 启动脚本 - 128MB LXC 小鸡专用

# 1. 杀掉旧进程
pkill -f "V2bX server"

# 2. 进入 V2bX 目录
cd /usr/local/V2bX || exit

# 3. 启动 V2bX（后台运行，关闭 watcher，无日志）
nohup ./V2bX server -w=false >/dev/null 2>&1 &

echo "V2bX started at $(date)"
