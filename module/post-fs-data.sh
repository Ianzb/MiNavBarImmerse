#!/system/bin/sh

MODDIR=${0%/*}

# 导入函数库
. "$MODDIR/functions.sh"

echo "正在应用 MiNavBarImmerse 配置文件..."

# 检查系统
get_system_version || abort "获取系统版本号失败"
check_config_file || abort "检查配置文件失败"
check_files_exist || abort "检查必要文件失败"
# 执行备份
backup_config || abort "备份配置文件失败"
# 应用配置（防止被云控覆盖）
apply_custom_config || abort "应用配置文件失败"

echo "MiNavBarImmerse 配置已成功应用！"
