# [小米小白条沉浸优化（MiNavBarImmerse）](https://ianzb.github.io/project/MiNavBarImmerse.html)

小米小白条沉浸优化（MiNavBarImmerse）是一个通过替换Xiaomi HyperOS 2.2内置第三方应用小白条配置文件，实现小白条沉浸优化的Magisk模块。

# 交流 & 反馈群组
加入我们所创建的群组以反馈问题或是了解最新情况。

[![badge_trguild]][trguild_url]

# 使用

在Release下载最新打包的.zip文件。

刷入Magisk模块并重启即可使用，初次刷入由于系统读取配置文件机制，需要重启两次系统生效，更新模块后重启可以立即生效。

由于暂时不了解系统云控适配列表的下发机制，因此长时间使用后可能会被系统覆盖适配文件，可以选择手动运行`post-fs-data.sh`或者重新安装模块提前替换，否则也需要重启两次后模块才能成功覆盖源文件。

# 适配范围

搭载Xiaomi HyperOS 2.2 - 3的机型，解锁root权限，能够刷入Magisk标准的模块。

# 开发

在[list.csv](list.csv)查看已适配应用信息。  
在[rule.md](rule.md)查看适配教程和说明。  
在[议题（Issue）](https://github.com/Ianzb/MiNavBarImmerse/issues)中提出适配要求，并提供信息。  
在[讨论（Discussion）](https://github.com/Ianzb/MiNavBarImmerse/discussions)中查看适配经验分享，并分享你的经验。  
在[拉取请求（Pull Request）](https://github.com/Ianzb/MiNavBarImmerse/pulls)中参与仓库贡献。  
在[Telegram群组](https://t.me/MiNavBarImmerse)中与其他贡献者交流，并下载最新文件。
另外，如果需要频繁参与适配工作，也可发出Issue申请协作者权限。

# 历史

[![Star History Chart](https://api.star-history.com/svg?repos=Ianzb/MiNavBarImmerse&type=Date)](https://www.star-history.com/#Ianzb/MiNavBarImmerse&Date)




[trguild_url]: https://t.me/MiNavBarImmerse

[badge_trguild]: https://img.shields.io/badge/TG-频道-4991D3?style=for-the-badge&logo=telegram