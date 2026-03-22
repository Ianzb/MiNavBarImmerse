#!/system/bin/sh

MODDIR=$MODPATH

# 导入函数库
. "$MODDIR/functions.sh"

ui_print " "
ui_print "============================="
ui_print "==     MiNavBarImmerse     =="
ui_print "============================="

if handle_choice "是否自动识别适用于当前系统的配置文件？" "是: 自动（推荐）" "否: 手动（移植包）"; then
    # 自动识别
    
    get_system_version
    check_config_file
    check_module_file

else
    # 手动识别
    
    if handle_choice "您当前使用的系统版本是否为 HyperOS 3 及以上？" "是: HyperOS 3+" "否: HyperOS 2.2"; then
        if handle_choice "您使用的是否是 HyperOS 3.3 及以上版本的系统？" "是" "否"; then
            MODE="33"
            RULE_FILE="$RULE_33"
            TARGET_FILE="$TARGET_33"
            BACKUP_FILE="$BACKUP_33"
        else
            MODE="30"
            RULE_FILE="$RULE_30"
            TARGET_FILE="$TARGET_30"
            BACKUP_FILE="$BACKUP_30"
        fi
    else
        MODE="22"
        RULE_FILE="$RULE_22"
        TARGET_FILE="$TARGET_22"
        BACKUP_FILE="$BACKUP_22"
    fi
fi

ui_print " "
ui_print "正在执行备份"

backup_config

ui_print " "
ui_print "正在应用配置文件"
apply_custom_config
update_module_description

ui_print "--------------------"
ui_print "安装成功！"
ui_print "重启系统生效！"
ui_print "--------------------"