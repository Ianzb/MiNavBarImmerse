
**Lang:** 
[![zh_CN](https://img.shields.io/badge/rule.md-简体中文-blue)](rule.md)
[![en_US](https://img.shields.io/badge/rule.md-English%20(US)-blue)](doc/en_us/rule.md)

---

# 适配说明

## 原理

模块通过替换/data/system/cloudFeature_navigation_bar_immersive_rules_list.xml生效，规则位于[immerse_rules.xml](/module/immerse_rules.xml)，模块内的文件是基于源文件修改得来的。

## 教程

NBIRules标签内为应用列表，格式为：
`<package name="应用包名" enable="true" activityRule="规则列表" disableVersionCode="818"/>`  
其中disableVersionCode可以不填。

其中，规则列表格式为：  
`规则1,规则2……`

规则格式为：  
`Activity ID:适配方式`

- 特殊地，可以使用`*`指代该应用的全部Activity。

适配方式用数字表示，规则如下：

- `0`：应用默认样式。
- `1:颜色`：小白条背景为指定颜色（ARGB格式），颜色使用有符号32位整数表示（十六进制->十进制->-2^32）；也可以使用小写英文单词表示（如white），可用范围未知，不推荐使用。
    - `1:0`：透明（0x00000000）。
    - `1:-16777216`：不透明黑色（0xFF000000）。
    - `1:-1`：不透明白色（0xFFFFFFFF）。
- `2`：小白条悬浮显示在应用上方，可能会有遮挡。

## 推荐

对于大多数应用可以全局应用悬浮显示+主界面默认/取色，来快速适配。

你可以在这里获取针对特定应用的[一些经验](https://github.com/Ianzb/MiNavBarImmerse/discussions)，并分享你的经验。

由于作者精力有限，不会主动适配不常用或者自己不用的软件。提交Issue时请给出截图、应用包名、必需的Activity适配信息和具体适配要求；PR时建议在本地提前进行验证，填写[list.csv](list.csv)，修改[changelog.md](changelog.md)。
对于部分大厂软件可能无法生效。

### 悬浮显示

* 推荐在需要上下滑动的信息流Activity，包括大多数软件的搜索、设置、地图等页面使用，需要底部无底栏等固定组件。
* 如果软件本身在大量页面共用了一个Activity，且该Activity在不同页面的UI差异较大，可以考虑使用，如果发现部分页面遮挡内容，影响使用，且原来的效果也不是那么难以接受，请放弃适配。

### 取色

* 对于有底栏的Activity，可以使用底栏背景颜色取色。
* 由于不支持动态取色，请不要在支持主题/皮肤/深浅色的界面使用。
* 如果仅对应用自带的颜色填充适配不满意，但是又无法使用取色适配多种颜色，先维持默认。

* 少部分应用自带的适配会导致无法被模块覆盖，暂时无解。部分应用会在部分页面卡出变黑等Bug，请果断放弃适配。

