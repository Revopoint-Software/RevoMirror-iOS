# Modifications to Moonlight iOS

RevoMirror-iOS is a derivative work based on
[Moonlight iOS/tvOS](https://github.com/moonlight-stream/moonlight-ios)
(licensed under GPL-3.0).

This document records the modifications made to the original Moonlight iOS
source code, in compliance with Section 5 of the GNU General Public License
v3.0, which requires modified versions to carry prominent notices stating that
the files were changed and the date of any change.

> **Note:** Files newly added by Revopoint Software, including most `RMI_*`
> view, utility, localization, resource, and legal document files under
> `RevoMirror-iOS`, are new RevoMirror-iOS application code rather than
> direct modifications of existing Moonlight files. This document focuses on
> changes made to original Moonlight iOS files and renamed/reworked derivatives
> of those files.

---

## Base Version

- **Upstream project:** Moonlight iOS/tvOS
- **Based on version / commit:** `Commits on Dec 21, 2024` 
- **Fork date:** 2025-08-11

---

## Summary of Modifications

| Date | Modified File(s) | Description of Change | Reason / Intent |
|------|------------------|-----------------------|-----------------|
| 2026-07-13 | `Moonlight.xcodeproj` -> `RevoMirror.xcodeproj`, `Limelight/` -> `RevoMirror/`, `Limelight-Info.plist`, `main.m`, `AppDelegate.*` | 将 iOS App 工程、Target、Bundle、显示名称和源码目录从 Moonlight/Limelight 调整为 RevoMirror；移除 tvOS Target 相关工程组织，更新版本、Bundle ID、签名团队和启动配置 | 将 Moonlight iOS 改造为 RevoMirror iOS 应用并匹配发布包名、品牌和启动入口 |
| 2026-07-13 | `MainFrameViewController.*`, `StreamFrameViewController.*`, `SettingsViewController.*`, `UIComputerView.*`, `ComputerScrollView.*`, `AppCollectionView.*`, `iPhone.storyboard`, `iPad.storyboard` | 重构主界面和串流界面为 RevoMirror 镜像流程，新增主机选择、无 Wi-Fi 提示、设置入口、自定义弹窗、连接后自动选择首个应用并进入投屏 | 将原 Moonlight 游戏列表/启动体验改为 RevoMirror 的设备投屏体验 |
| 2026-07-13 | `DataManager.*`, `TemporaryHost.*`, `TemporaryApp.*`, `TemporarySettings.*`, `StreamConfiguration.*`, `StreamManager.*`, `CryptoManager.*`, `IdManager.*`, `Utils.*` | 将数据、证书、设备 ID、串流配置和工具类重命名为 `RMI_*`，并适配 RevoMirror 的设置保存、默认主机、语言状态和当前窗口/导航获取逻辑 | 统一 RevoMirror 命名空间，支持新的 UI、设置页和投屏启动流程 |
| 2026-07-13 | `DiscoveryManager.*`, `DiscoveryWorker.*`, `MDNSManager.*`, `PairManager.*`, `HttpManager.*`, `ConnectionHelper.*`, `ServerInfoResponse.*`, `AppListResponse.*` | 保留 Moonlight/Sunshine 发现、配对和请求流程，同时适配 `RMI_*` 数据模型、RevoMirror 多语言文案、网络错误提示和局域网限制提示 | 支持 RevoMirror 发现 Sunshine 主机、完成配对并在投屏流程中提供本地化错误反馈 |
| 2026-07-13 | `RMI_MainViewController.m`, `RMI_StreamViewController.m`, `RMI_StreamManager.m`, `ControllerSupport.*`, `StreamView.*`, `RelativeTouchHandler.*`, `OnScreenControls.*` | 调整默认串流配置和交互：按设备屏幕像素写入分辨率、默认 60 FPS、绝对触控模式、PC 端播放音频、连接后直接进入串流；串流页新增返回按钮、网络/连接提示和 RevoMirror UI 样式 | 面向投屏场景优化默认体验，减少游戏选择步骤并适配横屏镜像控制 |
| 2026-07-13 | `Images.xcassets`, `Launch Screen.storyboard`, `Limelight-Info.plist`, `source/*.pdf` | 替换 App 图标、启动图、主机状态图标、设置/关于/返回/网络提示资源；新增用户协议、隐私政策和 GPLv3 协议 PDF 入口 | 替换 Moonlight 品牌资源，补充 RevoMirror 发布所需的用户协议、隐私政策和 GPL 许可展示 |
| 2026-07-13 | `moonlight-common/moonlight-common.xcodeproj/project.pbxproj` | Xcode 工程引用发生调整；未发现 `moonlight-common-c` 底层 C 源码的实质修改 | 配合 RevoMirror 工程组织和构建引用调整 |

---

## Detailed Notes

### 1、工程与应用标识
- **改动内容：** `Moonlight.xcodeproj` 重命名/调整为 `RevoMirror.xcodeproj`，App Target 改为 `RevoMirror`，iOS Deployment Target 调整为 13.0。
- **改动原因：** 需要将 Moonlight iOS 打包为 RevoMirror iOS 客户端。
- **影响范围：** 影响 iOS App 构建、签名、安装包标识、启动界面和系统权限提示文案。

### 2、主界面与投屏流程
- **改动内容：** 原 `MainFrameViewController` 重构为 `RMI_MainViewController`，删除原侧边菜单/设置控制器，新增 RevoMirror 主机列表、设置入口、无 Wi-Fi 页面、自定义弹窗和连接主机后自动进入串流的流程。
- **改动原因：** RevoMirror 主要面向设备投屏，不再以 Moonlight 原有游戏库浏览作为核心入口。
- **影响范围：** 影响主机展示、配对提示、应用列表获取、启动串流和用户错误反馈。

### 3、串流与输入体验
- **改动内容：** 原 `StreamFrameViewController`、`StreamManager`、`StreamConfiguration` 调整为 `RMI_StreamViewController`、`RMI_StreamManager`、`RMI_StreamConfiguration`；默认按设备屏幕分辨率保存串流尺寸，使用 60 FPS、绝对触控、音频在 PC 端播放，并在串流页增加 RevoMirror 返回按钮和横屏布局适配。
- **改动原因：** 适配投屏场景的默认画面比例、控制方式和退出方式。
- **影响范围：** 影响串流启动参数、触控交互、返回流程、统计浮层和连接失败提示。

### 4、网络发现、配对与连接
- **改动内容：** `DiscoveryManager`、`PairManager`、`HttpManager`、`ConnectionHelper` 等网络流程保留 Moonlight/Sunshine 协议基础，替换为 `RMI_*` 数据模型和 RevoMirror 本地化提示；新增网络可达性监听，非 Wi-Fi 或不可达时显示无网络提示。
- **改动原因：** 在复用 Moonlight 连接协议的基础上，适配 RevoMirror UI 和投屏连接路径。
- **影响范围：** 影响主机发现、手动添加、配对、连接失败提示和网络状态展示。

### 5、数据模型、工具类与多语言
- **改动内容：** `DataManager`、`TemporaryHost`、`TemporaryApp`、`TemporarySettings`、`CryptoManager`、`IdManager`、`Utils` 等类重命名并调整为 `RMI_*`；新增多语言字符串、当前语言、最后连接主机、当前窗口/导航查找等 RevoMirror 工具能力。
- **改动原因：** 统一 RevoMirror 命名空间，支撑新的设置页、多语言切换、主机记录和 UI 交互。
- **影响范围：** 影响持久化设置、主机/应用缓存、证书和设备 ID 读取、全局语言与界面刷新。

### 6、资源、设置页与许可入口
- **改动内容：** 替换 App Icon、启动页、主机状态、设置、返回、网络提示等资源；新增 `RMI_SetViewController`、关于页、用户协议、隐私政策和 GPLv3 协议 PDF。
- **改动原因：** 满足 RevoMirror 品牌展示、产品设置和 GPL-3.0 许可展示需求。
- **影响范围：** 影响 UI 资源、关于页面、设置页面和应用内许可/政策展示。

### 7、moonlight-common
- **改动内容：** 对比显示 `moonlight-common-c` 源码未发现实质改动，差异主要集中在 `moonlight-common.xcodeproj/project.pbxproj` 工程引用。
- **改动原因：** 配合 RevoMirror 工程组织和构建配置。
- **影响范围：** 影响 Xcode 工程引用，不影响底层串流协议库源码逻辑。

---

## Copyright of Modifications

All modifications described above are:

Copyright (C) 2026 Revopoint Software
(Xi'an Chishine Optoelectronics Technology Co., Ltd.)

These modifications are licensed under the GNU General Public License v3.0,
consistent with the license of the original Moonlight iOS/tvOS project.
