#!/system/bin/sh

MODDIR=${0%/*}

# 在安装时立即运行 post-fs-data.sh 以替换配置
echo "正在初始化 MiNavBarImmerse 配置..."
sh "$MODPATH/post-fs-data.sh"
[ "$?" != "0" ] && abort "配置初始化失败"

echo "配置初始化完成"
