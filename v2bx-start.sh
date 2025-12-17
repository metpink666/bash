#!/bin/bash

V2BX_DIR="/usr/local/V2bX"
VB_CMD="/usr/local/bin/vb"

# 生成/覆盖本地快捷命令 vb
cat << 'EOF' > "$VB_CMD"
#!/bin/bash

while true; do
    echo "=== V2bX ==="
    echo "1. 检测运行状态"
    echo "2. 启动"
    echo "99. 退出"
    echo -n "选择: "
    read choice
    
    if [ "$choice" = "1" ]; then
        echo "状态:"
        ps aux | grep V2bX
        echo ""
        echo "按回车键继续..."
        read
    elif [ "$choice" = "2" ]; then
        pkill -f "V2bX server" 2>/dev/null
        cd /usr/local/V2bX || exit
        nohup ./V2bX server -w=false >/dev/null 2>&1 &
        echo "V2bX started at $(date)"
        echo ""
        echo "按回车键继续..."
        read
    elif [ "$choice" = "99" ]; then
        exit 0
    else
        echo "请重新选择："
    fi
done
EOF

chmod +x "$VB_CMD"
echo "本地命令 'vb' 已生成/更新，以后可直接输入 vb 启动 V2bX"
