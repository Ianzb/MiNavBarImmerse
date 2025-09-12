

# 一些经验

如果你也想为项目做出一些小小贡献，这些信息对你会很有帮助。

也希望你能够留下你的所见所闻，为后人省去不必要的摸索。

## 高德地图

### 15.18.0.2038

神人，首页 / 收藏夹 / 打车 / 公交地铁 / 消息 / 我的等绝大部分页面均为 `com.autonavi.map.activity.NewMapActivity`，导航栏规则 1 取色同页面底色而非导航栏底色，规则 2 布局错误显示于屏幕外，采用规则 1 ，建议摆。

## 美团

### 12.35.235

神人，首页 / 酒店民宿 / 闪购 / 看病买药页不响应规则 1 始终悬浮显示，团购页不响应规则 2 始终对底色取色无法沉浸，建议摆。

## 京东

### 15.1.50

神人，首页规则 1 无法正确取色，规则 2 导航栏布局错误显示于屏幕外，建议摆；

`com.jd.lib.ttt.page.TTTMultiPageActivity` 为国补页面，不响应规则 2 ，无法沉浸；

`com.jd.lib.productdetail.ProductDetailActivity` 为网购商详页，应用既有安全区，采用规则 2 悬浮显示；

`com.jingdong.common.jdreactFramework.activities.JDReactNativeCommonActivity` 为部分二级设置页。

## Telegram 和它的三方客户端朋友们

### 12.0.1

神人，怎么写规则统统不听不听王八念经，建议摆。

## 航旅纵横

### 8.2.9

神人，点击底栏 / 切换页面时小白条底色黑白来回切换，无法解决，采用规则 2 全局悬浮显示，建议摆。

## 闲鱼

### 7.22.60

适配很棒，几乎无穿帮

`com.idlefish.flutterbridge.flutterboost.boost.FishFlutterBoostActivity`为设置页 / 我的交易 / 收藏浏览 / 宝贝主题瀑布流 / 个人页等，鉴定为写 flutter 写的；

`com.idlefish.flutterbridge.flutterboost.boost.FishFlutterBoostTransparencyActivity`为右上角三点按钮弹出菜单。

## 小红书

### 8.57.0

适配很棒，几乎无穿帮

在笔记页点击顶栏作者信息进入个人页时页面仍然停留在前序展示笔记页的`com.xingin.matrix.notedetail.NoteDetailActivity`，考虑笔记页底栏垫高故对此活动采用规则 1，导致个人页底栏无法沉浸；若追求沉浸可将其更改为规则 2，将牺牲笔记页的底栏垫高；

`com.xingin.reactnative.ui.XhsReactActivity`为地址页。

## 网易云音乐

### 9.0.40

适配很棒，几乎无穿帮

首页 / 侧边栏均属于 `com.tencent.mm.ui.LauncherUI`，采用规则 1 取色为底栏底色，侧边栏因无底栏无法沉浸。

## 哔哩哔哩

### 8.9.0

适配很棒

视频页简介与评论均属于 `com.bilibili.ship.theseus.detail.UnitedBizDetailsActivit`，为保证简介页瀑布流沉浸采用规则 2 悬浮显示，导致评论页底部输入框无垫高被部分遮挡；若需要垫高可将其更改为规则 1，将牺牲简介页的瀑布流沉浸；

首次进入设置页小横条底色变为黑色，进入任意二级页面并滚动后退出有概率可恢复沉浸，抽象玄学；

`com.bilibili.lib.ui.ComposeActivity`为动态 / 专栏 / 部分设置页等新页面。

## 微信

### 8.0.62 - Play

首页 / 聊天页均属于 `com.tencent.mm.ui.LauncherUI`，相关页面大部分均具有底栏，采用规则 1 取色为底栏底色；首页右滑浮窗页 / 首页下滑小程序页因无底栏无法沉浸；

小程序因规则 1 取色无法响应其内部色彩模式变化，采用规则 2 全局悬浮显示，若要尝试可对 `com.tencent.mm.plugin.appbrand.ui.AppBrandUI00` 至 `com.tencent.mm.plugin.appbrand.ui.AppBrandUI04` 应用规则；

`com.tencent.mm.plugin.lite.ui.WxaLiteAppSheetUI` 为顶栏 `搜索` - 底部 `页面设置` 弹出菜单

## 支付宝

### 10.7.60.8100

`com.alipay.mobile.nebulax.xriver.activity.XRiverActivity` 广泛用于显示拓展 / 小程序页面，涵盖广泛建议摆烂；

小程序因支付宝小程序绝大多数仅支持浅色模式，将规则置 0 交由应用自行处理。若要尝试可对 `com.alipay.mobile.nebulax.xriver.activity.XRiverActivity$App01` 至 `com.alipay.mobile.nebulax.xriver.activity.XRiverActivity$App05` 应用规则；

`com.alipay.android.phone.xriver.bundlex.CSGAPushActivity` 为消息 - 通讯录 - 联系人页，仅支持浅色模式故写死浅色底色；

`com.antfortune.wealth.stock.StockMainActivity`，`com.antfortune.wealth.stock.common.cube.page.CubePageActivity` 为股票相关页面

## 淘宝

### 10.51.30.3

`com.taobao.themis.container.app.TMSActivity` 为国补 / 券与红包 /活动 / 客服等页面，涵盖广泛且不响应任何规则，建议摆；

`com.taobao.browser.BrowserActivity` 为网页套壳；

`com.taobao.weex.weexv2.page.WeexV2Activity` 为收藏页。

## 饿了么

### 11.26.8

首页不响应规则 1 始终悬浮显示，底栏无法垫高；

`me.ele.muise.page.WeexPageActivity `为订单 / 活动 / 客服等页面；

`me.ele.im.limoo.activity.LIMActivity` 为私聊页；

`me.ele.android.emagex.container.EMagexActivity` 为商详页。

## 大众点评

### 11.32.35

主播写了超级多规则现在主播也不记得谁是谁了。

反正能跑。

`com.dianping.nova.picasso.DPPicassoBoxActivity` 为美食 / `景点/门票` / `酒店/民宿` / 各类榜单 / 消息页 / 赞评粉丝列表 / 搜索页等，涵盖广泛；

`com.dianping.voyager.poi.GCPOIDetailActivity` 为 `休闲/玩乐`主页；

`com.dianping.gcmrn.ssr.GCMRNSSRActivity` 为 KTV / `洗浴/汗蒸` / `按摩/足疗` 等页面；

`com.dianping.shopshell.PexusPoiActivity` 为店铺页；

`com.meituan.android.mrn.container.MRNBaseActivity`, `com.meituan.android.mrn.container.MRNStandardActivity` 为订单提交相关页面；

`com.sankuai.xm.imui.session.SessionActivity` 为私聊页；

`com.meituan.msc.modules.container.MSCActivity` 为活动 / 客服页；

`com.dianping.movie.trade.home.MovieMainActivity` 为 `电影/演出` 主页；

``com.dianping.movie.activity.DpMovieDetailActivity`, `com.dianping.movie.trade.MovieTitansActivity` 为电影详情页；

`com.meituan.android.movie.tradebase.activity.MovieCinemaListActivity` 为影院列表页； 

`com.meituan.android.movie.tradebase.activity.SelectSeatActivity` 为选座页；

`com.meituan.android.movie.tradebase.activity.PaySeatActivity` 为订单支付页；

## 铁路12306

### 5.9.45

因现版本将所有界面封装为 H5 页面放入 `com.MobileTicket.ui.activity.MainActivity` 显示，采用规则 1 全局取色显示，暂未发现严重布局问题。

## Edge

### 139.0.3405.125

设置页不响应规则 2 始终对底色取色，无法沉浸。

## 小米运动健康

### 3.46.2

首页采用规则 1 时取色同页面底色而非导航栏底色，二级界面多数已适配小白条沉浸。