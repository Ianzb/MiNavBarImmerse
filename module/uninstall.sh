#!/system/bin/sh

# Magisk 模块卸载脚本
# 在模块卸载时自动恢复备份文件

MODDIR=${0%/*}
TARGET_FILE="/data/system/cloudFeature_navigation_bar_immersive_rules_list.xml"
BACKUP_FILE="${TARGET_FILE}.bak"

echo "正在卸载 MiNavBarImmerse..."

# 检查备份文件是否存在
if [ -f "$BACKUP_FILE" ]; then
    echo "找到备份文件，正在恢复..."

    # 恢复备份文件
    if cp -f "$BACKUP_FILE" "$TARGET_FILE"; then
        echo "已成功恢复原始文件！"

        # 删除备份文件
        rm -f "$BACKUP_FILE"
        echo "已删除备份文件！"
    else
        echo "恢复文件失败！"
        exit 1
    fi
else
    echo "未找到备份文件，跳过恢复！"
fi

# 统一还原目标文件权限（无论是否恢复备份，都确保权限还原）
if [ -f "$TARGET_FILE" ]; then
    echo "正在还原目标文件权限..."
    chmod 600 "$TARGET_FILE"
    chown system:system "$TARGET_FILE"
    echo "已还原文件权限！"
fi

echo "卸载完成！"