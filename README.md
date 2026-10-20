# Burger · Flutter App

根据 Pixso `burger / xd page` 中的 21 个手机界面开发的黑黄风格汉堡点餐 App。包含三张引导页、登录注册、验证码、位置确认、首页、六类菜单、商品详情、收藏、购物车、结算和账户设置。

![页面预览](docs/screenshots/overview.jpg)

## Android 安装包

- [Android 手机 arm64](dist/burger-arm64-v8a.apk)
- [x86_64 模拟器](dist/burger-x86_64.apk)
- [安装说明](dist/README.md)

## 启动

开发环境：Flutter 3.47.7 / Dart 3.13.5。图片和 Poppins 字体均打包到本地，运行时不需要下载图片或字体。

```powershell
flutter pub get
flutter devices
flutter run -d emulator-5554
```

也可以用 `flutter run -d chrome` 预览。iOS 源工程已生成，需在 macOS / Xcode 环境中构建和验证。

本机的 BlueStacks Android 9 模拟器需要为运行和截图命令补充 `--enable-software-rendering --no-enable-impeller` 两个参数。该兼容设置仅作用于本次启动。

## 体验流程

- 引导页可左右滑动。点击 **Set Delivery Location → Confirm Location** 进入首页。
- 登录演示：有效邮箱 + 至少 6 位密码。注册可继续填写手机号，演示验证码为 **1234**。
- 首页或分类选择商品，点击购物车图标加购；详情的心形按钮可收藏。
- 购物车可增减、删除商品；结算显示实时总价、收货地址和支付方式。
- 添加演示支付卡可使用测试号码 `4242424242424242`、未来有效期（如 `12/39`）及 3 位 CVC。
- **Place Order** 生成本地演示订单并显示确认，随后清空购物车。
- 个人资料页可编辑姓名、手机号、配送地址、通知偏好和支付卡尾号。

这是 UI 与本地状态演示。认证、短信、社交登录、实时地图、系统权限、推送和真实支付未接入后端；下单不扣款。密码修改仅做本地校验。语言和价格保持原稿的 English / USD。

## 文档与截图

- [项目结构与架构](docs/ARCHITECTURE.md)
- [全部页面及截图索引](docs/SCREENS.md)
- [测试与验证说明](docs/VALIDATION.md)
- [Pixso 原稿截图](docs/reference/overview.jpg)

## 验证与构建

```powershell
flutter analyze
flutter test
flutter drive --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d emulator-5554
flutter build apk --release --split-per-abi
```

运行截图存入 `docs/screenshots/`，与 `docs/reference/` 下的设计稿导出分开保存。集成测试使用独立演示数据，正常安装从空购物车开始。

## 实现原则

按功能分目录，使用 Flutter 原生 `ChangeNotifier + InheritedNotifier` 管理状态，只引入图标与本地偏好存储两项运行依赖。按钮、输入框、商品卡片、购物车行和导航共用组件。购物车、收藏、地址和偏好保存到本地；不保存密码、完整卡号或 CVC。

设计图及食物、头像素材来自当前用户提供的 Pixso 文件；后续使用应遵循原素材权利。Poppins 字体许可位于 `assets/fonts/OFL.txt`。
