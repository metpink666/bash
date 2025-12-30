#!/bin/bash

# 删除并重新安装
sudo rm -rf /opt/metpink
sudo git clone https://github.com/metpink666/bash.git /opt/metpink
bash /opt/metpink/init.sh

MP_CMD="/usr/local/bin/mp"

# 生成/覆盖本地快捷命令 mp
cat << 'EOF' > "$MP_CMD"
#!/bin/bash

while true; do
    clear
    echo "————————————————————————————————————————————"
    echo "             泠 の 专用一键脚本             "
    echo "————————————————————————————————————————————"
    echo "             [1]:  脚本1             "
    echo "             [2]:  脚本2                     "
    echo "             [9]:  退出                     "
    echo "————————————————————————————————————————————"
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
        9)
            clear
            exit 0
            ;;
    esac
done
EOF

chmod +x "$MP_CMD"
echo "本地命令 'mp' 已生成/更新，以后可直接输入 mp 启动 '泠 の 专用一键脚本'"
