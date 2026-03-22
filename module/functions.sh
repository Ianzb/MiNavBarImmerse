#!/system/bin/sh

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
ORIGINAL_DESCRIPTION="通过替换 HyperOS 2.2 - 3.3 内置第三方应用小白条配置文件，实现小白条沉浸优化"


KEY_LISTENER_PID=""
KEY_FIFO=""

start_key_listener() {
    if [ -n "$KEY_LISTENER_PID" ] && kill -0 "$KEY_LISTENER_PID" 2>/dev/null; then
        return
    fi
    KEY_FIFO=$(mktemp -u -p /dev/tmp)
    mkfifo "$KEY_FIFO" || exit 1
    getevent -ql > "$KEY_FIFO" &
    KEY_LISTENER_PID=$!
}

stop_key_listener() {
    if [ -n "$KEY_LISTENER_PID" ]; then
        kill "$KEY_LISTENER_PID" >/dev/null 2>&1
        KEY_LISTENER_PID=""
    fi
    if [ -n "$KEY_FIFO" ]; then
        rm -f "$KEY_FIFO"
        KEY_FIFO=""
    fi
}

volume_key_detection() {
    local timeout_seconds="${1:-0}"
    local detection_result_file=$(mktemp -u -p /dev/tmp)
    
    (
        while read -r line; do
            if echo "$line" | grep -Eiq "(KEY_)?VOLUME ?UP|KEYCODE_VOLUME_UP" && echo "$line" | grep -Eiq "DOWN|PRESS"; then
                echo "0" > "$detection_result_file"
                exit 0
            elif echo "$line" | grep -Eiq "(KEY_)?VOLUME ?DOWN|KEYCODE_VOLUME_DOWN" && echo "$line" | grep -Eiq "DOWN|PRESS"; then
                echo "1" > "$detection_result_file"
                exit 0
            fi
        done < "$KEY_FIFO"
    ) &
    local detection_pid=$!
    
    if [ "$timeout_seconds" -gt 0 ]; then
        (
            sleep "$timeout_seconds"
            if kill -0 "$detection_pid" 2>/dev/null; then
                kill "$detection_pid" 2>/dev/null
                echo "2" > "$detection_result_file"
            fi
        ) &
        local timeout_pid=$!
        
        wait "$detection_pid" 2>/dev/null
        kill "$timeout_pid" 2>/dev/null
        wait "$timeout_pid" 2>/dev/null
    else
        wait "$detection_pid" 2>/dev/null
    fi
    
    if [ -f "$detection_result_file" ]; then
        local result=$(cat "$detection_result_file")
        rm -f "$detection_result_file"
        return "$result"
    fi
    
    rm -f "$detection_result_file"
    return 2
}

handle_choice() {
    local question="$1"
    local choice_yes="${2:-是}"
    local choice_no="${3:-否}"
    local timeout_seconds="${4:-10}"

    ui_print " "
    ui_print "--------------------------------------------------"
    ui_print "- ${question}"
    ui_print "- [ 音量加(+) ]: ${choice_yes}"
    ui_print "- [ 音量减(-) ]: ${choice_no}"
    ui_print "- [ ${timeout_seconds} 秒内未选择将默认选择: ${choice_yes} ]"

    timeout 0.1 getevent -c 1 >/dev/null 2>&1

    start_key_listener
    volume_key_detection "$timeout_seconds"
    local result=$?
    stop_key_listener
    
    if [ "$result" -eq 0 ]; then
        ui_print "  => 您选择: ${choice_yes}"
        return 0
    elif [ "$result" -eq 1 ]; then
        ui_print "  => 您选择: ${choice_no}"
        return 1
    else
        ui_print "  => 超时未选择，默认选择: ${choice_yes}"
        return 0
    fi
}

get_system_version() {
    VERSION_INCREMENTAL=$(getprop ro.build.version.incremental 2>/dev/null)
    
    if [ -z "$VERSION_INCREMENTAL" ]; then
        ui_print " "
        ui_print "无法获取系统版本号"
        return 1
    fi
    
    ui_print "当前系统版本: $VERSION_INCREMENTAL"
    
    CLEAN_VERSION=$(echo "$VERSION_INCREMENTAL" | sed 's/[^0-9.]*//g')
    VERSION_CORE=$(echo "$CLEAN_VERSION" | cut -d. -f1-3)
    
    if [ -z "$VERSION_CORE" ] || [ "$VERSION_CORE" = "$VERSION_INCREMENTAL" ]; then
        ui_print "错误: 无法解析的系统版本号格式！ $VERSION_INCREMENTAL"
        return 1
    fi
    
    MAJOR=$(echo "$VERSION_CORE" | cut -d. -f1)
    PATCH=$(echo "$VERSION_CORE" | cut -d. -f3)
}

check_config_file() {
    ui_print "正在检查配置文件"

    if [ -f "$SYSTEM_JSON_FILE" ]; then
        if [ "$PATCH" -ge 300 ]; then
            MODE="33"
            RULE_FILE="$RULE_33"
            TARGET_FILE="$TARGET_33"
            BACKUP_FILE="$BACKUP_33"
            ui_print "使用 HyperOS 3.3 配置文件"
        else
            MODE="30"
            RULE_FILE="$RULE_30"
            TARGET_FILE="$TARGET_30"
            BACKUP_FILE="$BACKUP_30"
            ui_print "使用 HyperOS 3.0 配置文件"
        fi
    elif [ -f "$SYSTEM_XML_FILE" ]; then
        MODE="22"
        RULE_FILE="$RULE_22"
        TARGET_FILE="$TARGET_22"
        BACKUP_FILE="$BACKUP_22"
        ui_print "使用 HyperOS 2.2 配置文件"
    else
        ui_print "错误: 未找到系统配置文件！"
        ui_print "请检查路径:"
        ui_print "$SYSTEM_JSON_FILE"
        ui_print "$SYSTEM_XML_FILE"
        return 1
    fi

    return 0
}

need_backup() {
    # 如果标记文件不存在，说明需要备份
    if [ ! -f "$MARKER_FILE" ]; then
        return 0  # 需要备份
    else
        return 1  # 不需要备份
    fi
}

# 创建标记文件
create_marker() {
    touch "$MARKER_FILE"
    chmod 600 "$MARKER_FILE"
    chown system:system "$MARKER_FILE"
}

# 删除标记文件
remove_marker() {
    if [ -f "$MARKER_FILE" ]; then
        rm -f "$MARKER_FILE"
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
    if cp -f "$RULE_FILE" "$TARGET_FILE"; then
        ui_print "配置文件替换成功！"

        # 设置正确权限
        chmod 600 "$TARGET_FILE"
        chown system:system "$TARGET_FILE"

        return 0
    else
        ui_print "配置文件替换失败！"
        return 1
    fi
}

# 检查文件是否存在
check_module_file() {
    if [ ! -f "$RULE_FILE" ]; then
        ui_print "错误: 自定义配置文件不存在: $RULE_FILE"
        ui_print "请检查模块完整性或尝试重新下载模块！"
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
        ui_print "找到备份文件，正在恢复..."

        if cp -f "$BACKUP_FILE" "$TARGET_FILE"; then
            ui_print "已成功恢复原始文件！"

            # 删除备份文件
            rm -f "$BACKUP_FILE"
            ui_print "已删除备份文件！"
        else
            ui_print "恢复文件失败！"
        fi
    else
        rm -f "$TARGET_FILE"
        ui_print "未找到备份文件，直接删除自定义配置文件！"
    fi
    restore_permissions
}

restore_permissions() {
    if [ -f "$TARGET_FILE" ]; then
        ui_print "正在还原目标文件权限..."
        chmod 600 "$TARGET_FILE"
        chown system:system "$TARGET_FILE"
        ui_print "已还原文件权限！"
    fi
}

update_module_description() {
    local status_info=$(generate_status_info)
    
    cp "$MODULE_PROP_FILE" "${MODULE_PROP_FILE}.bak"
    
    sed -i "s/^description=.*/description=$status_info | $ORIGINAL_DESCRIPTION/" "$MODULE_PROP_FILE"
}

generate_status_info() {
    local status=""
    local config_version=""
    
    if [ -f "$MARKER_FILE" ]; then
        status="✓ 替换成功"
    else
        status="✗ 替换失败"
    fi
    
    if [ "$MODE" = "33" ]; then
        config_version="HyperOS 3.3"
    elif [ "$MODE" = "30" ]; then
        config_version="HyperOS 3.0"
    elif [ "$MODE" = "22" ]; then
        config_version="HyperOS 2.2"
    else
        config_version="未识别到配置文件类型"
    fi

    echo "${status} (${config_version})"
}

