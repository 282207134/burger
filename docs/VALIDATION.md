# 测试与验证

日期：2026-10-21。

## 环境

| 项目 | 版本 / 配置 |
| --- | --- |
| 开发系统 | Windows 11，PowerShell |
| Flutter / Dart | Flutter 3.47.7 stable / Dart 3.13.5 |
| Android 设备 | BlueStacks，SM S908E，Android 9 / API 28，x86_64 |
| 截图尺寸 | 750 × 1624 实际像素，对应 375 × 812 逻辑尺寸 |
| 适配检查 | 375 × 812、320 × 700 |
| 模拟器渲染 | `--enable-software-rendering --no-enable-impeller` |

## 已通过检查

### 静态检查

`flutter analyze --no-pub`：无问题。

### 单元测试

`flutter test --no-pub --reporter expanded`：5 项通过。

- 购物车合并数量、实时总额、删除与 99 件数量上限。
- 快速连续修改后的持久化顺序与重新加载。
- 空购物车禁止下单，下单后清空购物车并保留收藏与地址。
- 无效 JSON、失效商品与无效数量的恢复处理。
- 邮箱、手机号、密码、卡号校验和及有效期校验。

### Android 界面与集成测试

```powershell
flutter drive --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d emulator-5554 --no-pub --enable-software-rendering --no-enable-impeller
```

结果：全部通过。

- 两种逻辑尺寸逐页渲染，没有布局溢出；包括参考界面及收藏扩展页。
- 登录邮箱先验证，再进入密码页。
- 加购后切换购物车时清除旧提示，结算按钮可立即点击。
- 三张引导页滑动、全部参考页面及三个长页滚动截图。
- 分类 → 商品详情 → 收藏 → 加购 → 修改数量 → 结算。
- 输入演示支付卡、校验并保存尾号、选择支付方式。
- 核对总价 125 美元，提交演示订单，确认购物车清空并返回首页。

本机 Windows `flutter_tester` 在界面渲染时出现过 `0xC0000005` 原生退出；界面与适配测试统一放到 Android 设备执行。普通 `flutter test` 保留无图形依赖的业务单元测试。

## 截图交付

- `docs/reference/01.png` 至 `21.png`：Pixso 原稿导出。
- `docs/screenshots/`：26 张 Flutter 运行截图。
- 21 张参考页面、3 张长页下半部分、订单确认与空购物车各一张。
- `docs/screenshots/overview.jpg`：21 个页面的总览。
- [逐页截图索引](SCREENS.md)。

已人工查看总览及引导、首页、商品列表、结算和订单确认截图，确认图片、文字、按钮、黑黄配色和滚动内容显示正常。

## 构建与复现

完成全部测试后，单独执行打包，避免多个 Flutter 命令同时改写平台生成文件：

```powershell
flutter build apk --release --split-per-abi --target-platform android-arm64,android-x64
```

交付安装包放在 `dist/`，使用本地演示签名。Android 真机 arm64 与模拟器 x86_64 分开提供。

- arm64：`dist/burger-arm64-v8a.apk`，22,676,295 字节。
- x86_64：`dist/burger-x86_64.apk`，24,160,067 字节。
- 已安装最终 x86_64 发布包，验证启动、确认配送位置、关闭进程和重新启动；本地偏好读取与写入正常，重启后恢复到首页，未出现运行异常。
- [最终发布包的重启验证截图](release-home.png)。
- 发布压缩保留了本地存储 JNI 桥接与所需 Kotlin 运行时类型，安装验证使用真实本地存储。
- `dist/checksums.json` 保存两个交付包的 SHA-256 校验值。

iOS 和 Web 提供源工程，未完成对应平台的构建验证。认证、短信、推送、实时地图和真实支付属于待接入服务；测试中的订单及支付均为本地演示，不产生交易。
