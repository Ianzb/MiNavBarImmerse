#!/system/bin/sh

# MiNavBarImmerse 规则热加载脚本
# 用法: sh /data/adb/modules/MiNavBarImmerse/hot_reload.sh [规则文件路径]
#
# 不带参数: 使用模块内置规则文件热加载
# 带参数:   使用指定的规则文件热加载
#
# 需要 root 权限执行

TAG="[MiNavBarImmerse]"

# 获取模块目录
MODDIR="${0%/*}"

# 系统版本检测
get_system_version() {
    VERSION_INCREMENTAL=$(getprop ro.build.version.incremental 2>/dev/null)
    if [ -z "$VERSION_INCREMENTAL" ]; then
        echo "$TAG 错误: 无法获取系统版本号"
        return 1
    fi
    CLEAN_VERSION=$(echo "$VERSION_INCREMENTAL" | sed 's/[^0-9.]*//g')
    VERSION_CORE=$(echo "$CLEAN_VERSION" | cut -d. -f1-3)
    MAJOR=$(echo "$VERSION_CORE" | cut -d. -f1)
    PATCH=$(echo "$VERSION_CORE" | cut -d. -f3)
}

# 确定目标文件和规则文件
detect_config() {
    SYSTEM_JSON_FILE="/system_ext/etc/nbi/navigation_bar_immersive_rules_list.json"
    SYSTEM_XML_FILE="/system_ext/etc/nbi/navigation_bar_immersive_rules_list.xml"

    if [ -f "$SYSTEM_JSON_FILE" ]; then
        if [ "$PATCH" -ge 300 ]; then
            TARGET_FILE="/data/system/cloudFeature_navigation_bar_immersive_rules_list.json"
            DEFAULT_RULE="${MODDIR}/immerse_rules_33.json"
            echo "$TAG 检测到 HyperOS 3.3"
        else
            TARGET_FILE="/data/system/cloudFeature_navigation_bar_immersive_rules_list.json"
            DEFAULT_RULE="${MODDIR}/immerse_rules_30.json"
            echo "$TAG 检测到 HyperOS 3.0"
        fi
    elif [ -f "$SYSTEM_XML_FILE" ]; then
        TARGET_FILE="/data/system/cloudFeature_navigation_bar_immersive_rules_list.xml"
        DEFAULT_RULE="${MODDIR}/immerse_rules_22.xml"
        echo "$TAG 检测到 HyperOS 2.2"
    else
        echo "$TAG 错误: 未找到系统配置文件"
        return 1
    fi
}

# 执行热加载
do_reload() {
    local rule_src="$1"

    # 检查源文件
    if [ ! -f "$rule_src" ]; then
        echo "$TAG 错误: 规则文件不存在: $rule_src"
        return 1
    fi

    # 复制规则文件
    if cp -f "$rule_src" "$TARGET_FILE"; then
        chmod 600 "$TARGET_FILE"
        chown system:system "$TARGET_FILE"
        echo "$TAG 规则文件已更新: $TARGET_FILE"
    else
        echo "$TAG 错误: 复制规则文件失败"
        return 1
    fi

    # 触发服务端重载
    echo "$TAG 正在触发服务端重载..."
    cmd miui_navigation_bar_immersive update 2>&1
    local cmd_result=$?

    if [ $cmd_result -eq 0 ]; then
        echo "$TAG 服务端规则重载成功"
    else
        echo "$TAG 警告: 服务端重载命令返回 $cmd_result"
        echo "$TAG 可能需要手动重启才能生效"
    fi

    echo "$TAG 热加载完成! 新启动的 Activity 将使用新规则"
    echo "$TAG 已打开的 App 需要杀掉重进才能生效"
}

# 主流程
echo "$TAG ============================="
echo "$TAG   规则热加载"
echo "$TAG ============================="

# 检查 root
if [ "$(id -u)" -ne 0 ]; then
    echo "$TAG 错误: 需要 root 权限执行"
    echo "$TAG 请使用: su -c sh $0"
    exit 1
fi

# 检测系统版本
get_system_version || exit 1
detect_config || exit 1

# 确定使用的规则文件
if [ -n "$1" ]; then
    RULE_SRC="$1"
    echo "$TAG 使用指定规则文件: $RULE_SRC"
else
    RULE_SRC="$DEFAULT_RULE"
    echo "$TAG 使用模块内置规则文件: $RULE_SRC"
fi

# 执行热加载
do_reload "$RULE_SRC"
