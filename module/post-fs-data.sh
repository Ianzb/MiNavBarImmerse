#!/system/bin/sh

MODDIR=${0%/*}
CUSTOM_FILE="$MODDIR/immerse_rules.xml"
TARGET_FILE="/data/system/cloudFeature_navigation_bar_immersive_rules_list.xml"
BACKUP_FILE="${TARGET_FILE}.bak"

echo "正在应用 MiNavBarImmerse 配置文件..."

# 检查目标文件是否存在
if [ ! -f "$TARGET_FILE" ]; then
    echo "错误: 目标文件不存在: $TARGET_FILE"
    echo "请确保您的系统支持此功能！"
    exit 1
fi

# 检查自定义文件是否存在
if [ ! -f "$CUSTOM_FILE" ]; then
    echo "错误: 自定义规则文件不存在: $CUSTOM_FILE"
    echo "请确保模块正确安装！"
    exit 1
fi

# 创建备份（如果不存在）
if [ ! -f "$BACKUP_FILE" ]; then
    echo "正在备份原配置文件..."
    if cp "$TARGET_FILE" "$BACKUP_FILE"; then
        echo "备份成功创建: $BACKUP_FILE"
        # 设置备份文件权限与原始文件相同
        chmod 600 "$BACKUP_FILE"
        chown system:system "$BACKUP_FILE"
    else
        echo "备份失败，无法创建备份文件！"
        exit 1
    fi
else
    echo "备份文件已存在，跳过备份步骤！"
fi

# 应用自定义规则
echo "正在替换配置文件..."
if cp -f "$CUSTOM_FILE" "$TARGET_FILE"; then
    echo "配置文件替换成功！"
else
    echo "配置文件替换失败！"
    exit 1
fi

# 设置正确权限
chmod 600 "$TARGET_FILE"
chown system:system "$TARGET_FILE"

echo "MiNavBarImmerse 配置已成功应用！"
echo "需要重启系统才能使更改生效！"