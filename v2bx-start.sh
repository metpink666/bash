#!/bin/bash

V2BX_DIR="/usr/local/V2bX"
VB_CMD="/usr/local/bin/vb"

# 生成/覆盖本地快捷命令 vb
cat << 'EOF' > "$VB_CMD"
#!/bin/bash
# 简化启动 V2bX（带杀掉旧进程）
pkill -f "V2bX server" 2>/dev/null
cd /usr/local/V2bX || exit
nohup ./V2bX server -w=false >/dev/null 2>&1 &
echo "V2bX started at $(date)"
EOF

chmod +x "$VB_CMD"
echo "本地命令 'vb' 已生成/更新，以后可直接输入 vb 启动 V2bX"
