#!/bin/bash

# 删除并重新安装
sudo rm -rf /opt/metpink 2>/dev/null
sudo git clone https://github.com/metpink666/bash.git /opt/metpink
sudo chmod -R 755 /opt/metpink

MP_CMD="/usr/local/bin/mp"

# 生成/覆盖本地快捷命令 mp
cat << 'EOF' > "$MP_CMD"
#!/bin/bash

while true; do
    clear
    echo "╔══════════════════════════════════════════╗"
    echo "║              泠 の 专用一键脚本          ║"
    echo "╚══════════════════════════════════════════╝"
    echo "║             [ 1]:  脚本1                 ║   "
    echo "║             [ 2]:  脚本2                 ║    "
    echo "╔══════════════════════════════════════════╗"
    echo "║             [97]:  更新脚本              ║       "
    echo "║             [98]:  卸载脚本              ║       "
    echo "║               按回车键退出               ║      "
    echo "╚══════════════════════════════════════════╝"
    echo -n "       请选择:"
    read choice
    
    case "$choice" in
        1)
            clear
            bash /opt/metpink/scripts/v2bx.sh
            ;;
        2)
            clear
            bash /opt/metpink/scripts/v2bx.sh
            ;;
        97)
            clear
            cd /
            bash <(curl -s https://raw.githubusercontent.com/metpink666/bash/main/init.sh)
            echo "更新脚本成功，请输入 mp 启动 '泠 の 专用一键脚本'"
            exit 0
            ;;
        98)
            clear
            sudo rm -rf /opt/metpink /usr/local/bin/mp
            echo "/opt/metpink为所有数据目录，已清除"
            echo "/usr/local/bin/mp为mp快捷命令文件，已清除"
            echo "该脚本已完整清理干净"
            exit 0
            ;;
        "")
            clear
            exit 0
            ;;
    esac
done
EOF

chmod +x "$MP_CMD"
rm -f ./init.sh 2>/dev/null
clear
echo "安装脚本已清理干净，所有文件都在/opt/metpink/文件夹里"
echo "本地命令 'mp' 已生成/更新，以后可直接输入 mp 启动 '泠 の 专用一键脚本'"
