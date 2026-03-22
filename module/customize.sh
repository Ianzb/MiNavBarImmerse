#!/system/bin/sh

MODDIR=$MODPATH

# 导入函数库
. "$MODDIR/functions.sh"

echo "正在初始化 MiNavBarImmerse 配置..."

get_system_version || abort "获取系统版本号失败"
check_config_file || abort "检查配置文件失败"
check_files_exist || abort "检查必要文件失败"

echo "执行备份..."
backup_config || abort "备份配置文件失败"

apply_custom_config || abort "应用配置文件失败"

update_module_description || abort "更新状态失败"


echo "配置初始化完成"
echo "需要重启系统生效！"
