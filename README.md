# bash
泠の自用脚本

## 1. 一键安装
```bash
cd / && wget -N https://raw.githubusercontent.com/metpink666/bash/refs/heads/main/install.sh && bash install.sh
```

## 2. V2bX - lxc - debian 小鸡运行命令
> 最近碰到了一些内存小且系统过于精简的 lxc - debian 小鸡，实在是运行不了，研究半天终于解决

> 需要先运行官方V2bX并且生成配置文件，启动失败后运行此命令即可，官方脚本依旧会显示未运行，但是不影响
```bash
wget -N https://raw.githubusercontent.com/metpink666/bash/refs/heads/main/v2bx-start.sh && bash v2bx-start.sh
```
