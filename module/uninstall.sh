#!/system/bin/sh

MODDIR=${0%/*}

# 导入函数库
. "$MODDIR/functions.sh"

echo "正在卸载 MiNavBarImmerse..."

# 首先检查配置文件类型并设置正确的文件路径
if check_config_file; then
    echo "检测到配置类型: $MODE"
    echo "目标文件: $TARGET_FILE"
    echo "备份文件: $BACKUP_FILE"

    # 恢复备份
    restore_backup

    # 还原权限
else
    echo "警告: 无法确定配置文件类型，尝试清理两种格式..."

    # 尝试清理JSON格式
    echo "尝试清理JSON格式配置..."
    RULE_FILE="$RULE_33"
    TARGET_FILE="$TARGET_33"
    BACKUP_FILE="$BACKUP_33"
    restore_backup

    # 尝试清理XML格式
    echo "尝试清理XML格式配置..."
    RULE_FILE="$RULE_22"
    TARGET_FILE="$TARGET_22"
    BACKUP_FILE="$BACKUP_22"
    restore_backup
fi

echo "卸载完成！"
