# [小米小白条沉浸优化（MiNavBarImmerse）](https://ianzb.github.io/project/MiNavBarImmerse.html)

小米小白条沉浸优化（MiNavBarImmerse）是一个通过替换Xiaomi HyperOS 2.2内置第三方应用小白条配置文件，实现小白条沉浸优化的Magisk模块。

# 使用

在Release下载最新打包的.zip文件。

刷入Magisk模块并重启即可使用，初次刷入由于系统读取配置文件机制，需要重启两次系统生效，更新模块后重启可以立即生效。

由于暂时不了解系统云控适配列表的下发机制，因此长时间使用后可能会被系统覆盖适配文件，可以选择手动运行`post-fs-data.sh`或者重新安装模块提前替换，否则也需要重启两次后模块才能成功覆盖源文件。

# 适配范围

搭载Xiaomi HyperOS 2.2 - 3的机型，解锁root权限，能够刷入Magisk标准的模块。

# 开发

[点此](list.md)查看适配列表。  
[点此](rule.md)查看适配说明。  
[点此](experience.md)查看适配经验分享。  

欢迎大家踊跃参与仓库的贡献，提出Issue或提交PR。  

# 历史

[![Star History Chart](https://api.star-history.com/svg?repos=Ianzb/MiNavBarImmerse&type=Date)](https://www.star-history.com/#Ianzb/MiNavBarImmerse&Date)
