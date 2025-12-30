#!/bin/bash

# 配置 - 使用新目录结构
SERVICE_NAME="sing-box"  # 直接用 sing-box
SERVICE_DIR="/opt/metpink/services/singbox"  # services目录
INSTALL_DIR="$SERVICE_DIR"
CONFIG_FILE="$INSTALL_DIR/config.json"
LOG_FILE="/opt/metpink/logs/singbox.log"  # 统一日志目录

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_menu() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║          sing-box 管理面板                   ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    echo "        ┌─────────────────────────────┐"
    echo "        │   [1] 检测运行状态          │"
    echo "        │   [2] 安装 sing-box         │"
    echo "        │   [3] 配置SK5代理           │"
    echo "        │   [4] 启动服务              │"
    echo "        │   [5] 查看配置              │"
    echo "        │   [6] 停止服务              │"
    echo "        │   [7] 重启服务              │"
    echo "        └─────────────────────────────┘"
    echo ""
    echo "        🚪 按回车键返回主菜单"
    echo ""
    echo "════════════════════════════════════════════════"
    echo -n "       请选择: "
}

# 检测运行状态
check_status() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║            检测运行状态                      ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    # 通过配置文件路径识别当前实例
    if pgrep -f "$INSTALL_DIR/$SERVICE_NAME" > /dev/null; then
        echo -e "${GREEN}✅ sing-box 正在运行${NC}"
        echo "进程信息:"
        ps aux | grep -E "$INSTALL_DIR/$SERVICE_NAME" | grep -v grep
    else
        echo -e "${RED}❌ sing-box 未运行${NC}"
    fi
    
    # 检查安装目录
    echo ""
    echo "服务目录: $INSTALL_DIR"
    if [ -d "$INSTALL_DIR" ]; then
        echo -e "${GREEN}✅ 目录存在${NC}"
        ls -la "$INSTALL_DIR"
    else
        echo -e "${YELLOW}⚠️  目录不存在${NC}"
    fi
    
    # 检查日志文件
    echo ""
    echo "日志文件: $LOG_FILE"
    if [ -f "$LOG_FILE" ]; then
        echo -e "${GREEN}✅ 日志文件存在${NC}"
        echo "最后10行日志:"
        tail -n 10 "$LOG_FILE"
    fi
    
    echo ""
    echo "════════════════════════════════════════════════"
    echo "按回车键返回..."
    read
}

# 安装 sing-box
install_singbox() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║            安装 sing-box                     ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    # 创建目录结构
    echo "创建目录结构..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo mkdir -p "/opt/metpink/logs"
    sudo chown -R $(whoami):$(whoami) "$INSTALL_DIR"
    sudo chown -R $(whoami):$(whoami) "/opt/metpink/logs"
    
    # 检测系统架构
    ARCH=$(uname -m)
    case $ARCH in
        x86_64) ARCH="amd64" ;;
        aarch64) ARCH="arm64" ;;
        armv7l) ARCH="armv7" ;;
        *) echo -e "${RED}不支持的架构: $ARCH${NC}"; return 1 ;;
    esac
    
    # 获取最新版本
    echo "获取最新版本..."
    LATEST_VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}获取版本失败${NC}"
        return 1
    fi
    
    echo "最新版本: $LATEST_VERSION"
    
    # 下载 sing-box
    DOWNLOAD_URL="https://github.com/SagerNet/sing-box/releases/download/$LATEST_VERSION/sing-box-${LATEST_VERSION#v}-linux-$ARCH.tar.gz"
    
    echo "下载: $DOWNLOAD_URL"
    cd "$INSTALL_DIR"
    wget -q "$DOWNLOAD_URL" -O sing-box.tar.gz
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}下载失败${NC}"
        return 1
    fi
    
    # 解压
    echo "解压文件..."
    tar -xzf sing-box.tar.gz
    rm -f sing-box.tar.gz
    
    # 移动文件
    EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "sing-box*" | head -1)
    if [ -n "$EXTRACTED_DIR" ]; then
        mv "$EXTRACTED_DIR"/* .
        rm -rf "$EXTRACTED_DIR"
    fi
    
    # 不需要重命名，直接用 sing-box
    echo -e "${GREEN}✅ 安装完成！${NC}"
    echo "服务目录: $INSTALL_DIR"
    echo "执行文件: $INSTALL_DIR/$SERVICE_NAME"
    
    echo ""
    echo "════════════════════════════════════════════════"
    echo "按回车键返回..."
    read
}

# 配置SK5代理（简化版）
configure_sk5() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║            配置SK5代理                       ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    # 检查是否已安装
    if [ ! -f "$INSTALL_DIR/$SERVICE_NAME" ]; then
        echo -e "${RED}请先安装 sing-box${NC}"
        echo "按回车键返回..."
        read
        return 1
    fi
    
    echo "配置SK5代理（SOCKS5）"
    echo ""
    
    # 输入端口
    while true; do
        echo -n "请输入端口号 (默认: 1080): "
        read PORT
        if [ -z "$PORT" ]; then
            PORT=1080
        fi
        
        if [[ "$PORT" =~ ^[0-9]+$ ]] && [ "$PORT" -ge 1 ] && [ "$PORT" -le 65535 ]; then
            break
        else
            echo -e "${RED}端口号必须是1-65535之间的数字${NC}"
        fi
    done
    
    # 输入用户名
    echo -n "请输入用户名（直接回车留空）: "
    read USERNAME
    
    # 输入密码
    echo -n "请输入密码（直接回车留空）: "
    read -s PASSWORD
    echo ""
    
    # 生成最简单的配置
    echo "生成配置文件..."
    
    if [ -z "$USERNAME" ] && [ -z "$PASSWORD" ]; then
        # 无认证配置（最简单格式）
        cat > "$CONFIG_FILE" << EOF
{
    "log": {
        "level": "info",
        "output": "/opt/metpink/logs/singbox.log"
    },
    "inbounds": [
        {
            "type": "socks",
            "tag": "socks-in",
            "listen": "::",
            "listen_port": $PORT,
            "users": []
        }
    ],
    "outbounds": [
        {
            "type": "direct"
        }
    ]
}
EOF
        AUTH_INFO="无认证"
    else
        # 有认证配置（最简单格式）
        cat > "$CONFIG_FILE" << EOF
{
    "log": {
        "level": "info",
        "output": "/opt/metpink/logs/singbox.log"
    },
    "inbounds": [
        {
            "type": "socks",
            "tag": "socks-in",
            "listen": "::",
            "listen_port": $PORT,
            "users": [
                {
                    "username": "$USERNAME",
                    "password": "$PASSWORD"
                }
            ]
        }
    ],
    "outbounds": [
        {
            "type": "direct"
        }
    ]
}
EOF
        AUTH_INFO="用户名: $USERNAME"
    fi
    
    echo -e "${GREEN}✅ 配置生成完成！${NC}"
    echo "端口: $PORT"
    echo "认证: $AUTH_INFO"
    echo "配置文件: $CONFIG_FILE"
    echo "日志文件: $LOG_FILE"
    
    echo ""
    echo "════════════════════════════════════════════════"
    echo "按回车键返回..."
    read
}

# 启动服务
start_service() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║            启动 sing-box                     ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    # 检查是否已安装
    if [ ! -f "$INSTALL_DIR/$SERVICE_NAME" ]; then
        echo -e "${RED}请先安装 sing-box${NC}"
        echo "按回车键返回..."
        read
        return 1
    fi
    
    # 检查配置文件
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}请先配置SK5代理${NC}"
        echo "按回车键返回..."
        read
        return 1
    fi
    
    # 检查是否已在运行
    if pgrep -f "$INSTALL_DIR/$SERVICE_NAME" > /dev/null; then
        echo -e "${YELLOW}sing-box 已在运行${NC}"
        echo "按回车键返回..."
        read
        return 0
    fi
    
    # 启动服务
    echo "正在启动 sing-box..."
    cd "$INSTALL_DIR"
    nohup "./$SERVICE_NAME" run -c "$CONFIG_FILE" > "$LOG_FILE" 2>&1 &
    
    sleep 2
    
    if pgrep -f "$INSTALL_DIR/$SERVICE_NAME" > /dev/null; then
        echo -e "${GREEN}✅ sing-box 启动成功！${NC}"
        echo "日志文件: $LOG_FILE"
    else
        echo -e "${RED}❌ sing-box 启动失败${NC}"
        echo "请查看日志文件: $LOG_FILE"
    fi
    
    echo ""
    echo "════════════════════════════════════════════════"
    echo "按回车键返回..."
    read
}

# 查看配置
view_config() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║            查看配置                          ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    if [ -f "$CONFIG_FILE" ]; then
        echo "配置文件: $CONFIG_FILE"
        echo ""
        echo "════════════════════════════════════════════════"
        cat "$CONFIG_FILE" | python3 -m json.tool 2>/dev/null || cat "$CONFIG_FILE"
        echo "════════════════════════════════════════════════"
    else
        echo -e "${YELLOW}配置文件不存在${NC}"
        echo "请先配置SK5代理"
    fi
    
    echo ""
    echo "按回车键返回..."
    read
}

# 停止服务
stop_service() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║            停止 sing-box                     ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    if pgrep -f "$INSTALL_DIR/$SERVICE_NAME" > /dev/null; then
        echo "正在停止 sing-box..."
        pkill -f "$INSTALL_DIR/$SERVICE_NAME"
        sleep 2
        
        if pgrep -f "$INSTALL_DIR/$SERVICE_NAME" > /dev/null; then
            echo -e "${RED}停止失败，尝试强制停止...${NC}"
            pkill -9 -f "$INSTALL_DIR/$SERVICE_NAME"
        fi
        
        echo -e "${GREEN}✅ sing-box 已停止${NC}"
    else
        echo -e "${YELLOW}sing-box 未运行${NC}"
    fi
    
    echo ""
    echo "════════════════════════════════════════════════"
    echo "按回车键返回..."
    read
}

# 重启服务
restart_service() {
    clear
    echo "╔══════════════════════════════════════════════╗"
    echo "║            重启 sing-box                     ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    # 停止服务
    if pgrep -f "$INSTALL_DIR/$SERVICE_NAME" > /dev/null; then
        echo "正在停止 sing-box..."
        pkill -f "$INSTALL_DIR/$SERVICE_NAME"
        sleep 2
    fi
    
    # 启动服务
    echo "正在启动 sing-box..."
    cd "$INSTALL_DIR"
    nohup "./$SERVICE_NAME" run -c "$CONFIG_FILE" > "$LOG_FILE" 2>&1 &
    
    sleep 2
    
    if pgrep -f "$INSTALL_DIR/$SERVICE_NAME" > /dev/null; then
        echo -e "${GREEN}✅ sing-box 重启成功！${NC}"
    else
        echo -e "${RED}❌ sing-box 重启失败${NC}"
    fi
    
    echo ""
    echo "════════════════════════════════════════════════"
    echo "按回车键返回..."
    read
}

# 主循环
while true; do
    show_menu
    read choice
    
    case "$choice" in
        "")  # 空输入返回主菜单
            exit 0
            ;;
        1)
            check_status
            ;;
        2)
            install_singbox
            ;;
        3)
            configure_sk5
            ;;
        4)
            start_service
            ;;
        5)
            view_config
            ;;
        6)
            stop_service
            ;;
        7)
            restart_service
            ;;
        *)
            echo -e "${RED}无效选择${NC}"
            sleep 1
            ;;
    esac
done
