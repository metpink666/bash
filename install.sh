#!/bin/bash
# 删除并重新安装
sudo rm -rf /opt/metpink
sudo git clone https://github.com/metpink666/bash.git /opt/metpink
sudo chmod +x /opt/metpink/init.sh
bash /opt/metpink/init.sh
