#!/system/bin/sh

# MODDIR 变量由调用脚本定义

SYSTEM_JSON_FILE="/system_ext/etc/nbi/navigation_bar_immersive_rules_list.json"
SYSTEM_XML_FILE="/system_ext/etc/nbi/navigation_bar_immersive_rules_list.xml"

MODE=""
RULE_FILE=""
TARGET_FILE=""
BACKUP_FILE=""

# 文件路径
# Xiaomi HyperOS 3.3
RULE_33="${MODDIR}/immerse_rules_33.json"
TARGET_33="/data/system/cloudFeature_navigation_bar_immersive_rules_list.json"
BACKUP_33="${TARGET_33}.bak"

# Xiaomi HyperOS 3.0
RULE_30="${MODDIR}/immerse_rules_30.json"
TARGET_30="/data/system/cloudFeature_navigation_bar_immersive_rules_list.json"
BACKUP_30="${TARGET_30}.bak"

# Xiaomi HyperOS 2.2
RULE_22="${MODDIR}/immerse_rules_22.xml"
TARGET_22="/data/system/cloudFeature_navigation_bar_immersive_rules_list.xml"
BACKUP_22="${TARGET_22}.bak"

# 标记文件路径
MARKER_FILE="/data/system/MiNavBarImmerse"

# 模块属性文件路径
MODULE_PROP_FILE="${MODDIR}/module.prop"

# 原始描述文本
ORIGINAL_DESCRIPTION="通过Xiaomi HyperOS 2.2-3.3内置第三方应用小白条配置文件，实现小白条沉浸优化。"

# 获取系统版本号
get_system_version() {
    echo "正在解析系统版本号！"
    VERSION_INCREMENTAL=$(getprop ro.build.version.incremental 2>/dev/null)
    
    if [ -z "$VERSION_INCREMENTAL" ]; then
        echo "错误: 无法获取系统版本号！"
        return 1
    fi
    
    echo "检测到系统版本: $VERSION_INCREMENTAL"
    
    CLEAN_VERSION=$(echo "$VERSION_INCREMENTAL" | sed 's/[^0-9.]*//g')
    VERSION_CORE=$(echo "$CLEAN_VERSION" | cut -d. -f1-3)
    
    if [ -z "$VERSION_CORE" ] || [ "$VERSION_CORE" = "$VERSION_INCREMENTAL" ]; then
        echo "错误: 无法解析系统版本号格式！"
        echo "原始版本: $VERSION_INCREMENTAL"
        return 1
    fi
    
    echo "解析到的版本号: $VERSION_CORE"
    
    MAJOR=$(echo "$VERSION_CORE" | cut -d. -f1)
    PATCH=$(echo "$VERSION_CORE" | cut -d. -f3)
    
}


# 检查配置文件类型
check_config_file() {
    echo "正在检查配置文件..."

    # 检查系统配置文件类型
    if [ -f "$SYSTEM_JSON_FILE" ]; then
        if [ "$PATCH" -ge 300 ]; then
            MODE="33"
            RULE_FILE="$RULE_33"
            TARGET_FILE="$TARGET_33"
            BACKUP_FILE="$BACKUP_33"
            echo "系统版本符合要求，将使用3.3配置文件！"
        else
            MODE="30"
            RULE_FILE="$RULE_30"
            TARGET_FILE="$TARGET_30"
            BACKUP_FILE="$BACKUP_30"
            echo "系统版本符合要求，将使用3.0配置文件！"
        fi
    elif [ -f "$SYSTEM_XML_FILE" ]; then
        MODE="22"
        RULE_FILE="$RULE_22"
        TARGET_FILE="$TARGET_22"
        BACKUP_FILE="$BACKUP_22"
        echo "系统版本符合要求，将使用2.2配置文件！"
    else
        echo "错误: 未找到系统配置文件！"
        echo "检查路径:"
        echo "  $SYSTEM_JSON_FILE"
        echo "  $SYSTEM_XML_FILE"
        return 1
    fi

    echo "使用配置文件: $RULE_FILE"
    echo "目标文件: $TARGET_FILE"
    echo "备份文件: $BACKUP_FILE"

    return 0
}

# 检查是否需要备份
need_backup() {
    # 如果标记文件不存在，说明需要备份
    if [ ! -f "$MARKER_FILE" ]; then
        echo "标记文件不存在，需要创建备份"
        return 0  # 需要备份
    else
        echo "标记文件已存在，跳过备份"
        return 1  # 不需要备份
    fi
}

# 创建标记文件
create_marker() {
    echo "创建标记文件..."
    touch "$MARKER_FILE"
    chmod 600 "$MARKER_FILE"
    chown system:system "$MARKER_FILE"
    echo "标记文件创建完成: $MARKER_FILE"
}

# 删除标记文件
remove_marker() {
    if [ -f "$MARKER_FILE" ]; then
        echo "删除标记文件..."
        rm -f "$MARKER_FILE"
        echo "标记文件已删除: $MARKER_FILE"
    fi
}

# 备份原始配置文件
backup_config() {
    # 先检查是否需要备份
    if ! need_backup; then
        echo "无需备份，跳过备份步骤"
        return 0
    fi

    if [ -f "$TARGET_FILE" ]; then
        echo "正在备份原配置文件..."
        if cp "$TARGET_FILE" "$BACKUP_FILE"; then
            echo "备份成功创建: $BACKUP_FILE"
            # 设置备份文件权限与原始文件相同
            chmod 600 "$BACKUP_FILE"
            chown system:system "$BACKUP_FILE"

            # 创建标记文件，表示已备份过
            create_marker
            return 0
        else
            echo "备份创建失败！"
            return 1
        fi
    else
        echo "原始配置文件不存在，无需备份"
        create_marker
        return 0
    fi
}

# 应用自定义配置
apply_custom_config() {
    echo "正在替换配置文件..."
    if cp -f "$RULE_FILE" "$TARGET_FILE"; then
        echo "配置文件替换成功！"

        # 设置正确权限
        chmod 600 "$TARGET_FILE"
        chown system:system "$TARGET_FILE"

        return 0
    else
        echo "配置文件替换失败！"
        return 1
    fi
}

# 检查文件是否存在
check_files_exist() {
    if [ ! -f "$RULE_FILE" ]; then
        echo "错误: 自定义配置文件不存在: $RULE_FILE"
        echo "请确保模块完整！"
        return 1
    fi
    return 0
}

# 恢复备份配置
restore_backup() {
    # 首先删除标记文件
    remove_marker

    # 恢复备份文件（如果存在）
    if [ -f "$BACKUP_FILE" ]; then
        echo "找到备份文件，正在恢复..."

        if cp -f "$BACKUP_FILE" "$TARGET_FILE"; then
            echo "已成功恢复原始文件！"

            # 删除备份文件
            rm -f "$BACKUP_FILE"
            echo "已删除备份文件！"
        else
            echo "恢复文件失败！"
        fi
    else
        rm -f "$TARGET_FILE"
        echo "未找到备份文件，直接删除自定义配置文件！"
    fi
    restore_permissions
}

# 还原文件权限
restore_permissions() {
    if [ -f "$TARGET_FILE" ]; then
        echo "正在还原目标文件权限..."
        chmod 600 "$TARGET_FILE"
        chown system:system "$TARGET_FILE"
        echo "已还原文件权限！"
    fi
}

# 生成状态信息
generate_status_info() {
    local status=""
    local config_version=""
    
    # 检查是否安装成功
    if [ -f "$MARKER_FILE" ]; then
        status="✓ 替换成功"
    else
        status="✗ 替换失败"
    fi
    
    # 检查当前配置文件类型和版本
    if [ "$MODE" = "33" ]; then
        config_version="3.3 格式"
    elif [ "$MODE" = "30" ]; then
        config_version="3.0 格式"
    elif [ "$MODE" = "22" ]; then
        config_version="2.2 格式"
    else
        config_version="未识别到配置文件类型"
    fi
    
    # 生成状态信息
    echo "[状态] $status | 配置类型: $config_version"
}

# 更新模块介绍文本
update_module_description() {
    local status_info=$(generate_status_info)
    
    # 备份原始module.prop
    cp "$MODULE_PROP_FILE" "${MODULE_PROP_FILE}.bak"
    
    # 替换description字段
    sed -i "s/^description=.*/description=$status_info | $ORIGINAL_DESCRIPTION/" "$MODULE_PROP_FILE"

    echo "模块状态文本已更新！"
}