<div align="center">
  <img src="./RevoMirror/Images.xcassets/AppIcon.appiconset/icon-1024.png" alt="RevoMirror icon" width="120"/> 
  <h1 align="center">RevoMirror-iOS</h1>
  <h4 align="center">面向局域网低延迟投屏的 iOS 客户端。</h4>
</div>

<div align="center">
  <a href="README.md">English</a> | <b>简体中文</b>
</div>

## 项目简介

**RevoMirror-iOS** 是由 **Revopoint Software**
开发的 iOS 客户端，用于在局域网内进行低延迟屏幕投屏和远程交互。

本项目基于开源项目
[Moonlight iOS/tvOS](https://github.com/moonlight-stream/moonlight-ios)
二次开发，遵循 GPL-3.0 许可证。RevoMirror-iOS 复用了 Moonlight 成熟的
串流客户端基础能力，并针对 RevoMirror 的投屏流程、界面、设置、多语言和产品
品牌进行了适配。

RevoMirror-iOS 可与 RevoMirror-PC 或 Sunshine 等兼容主机配合使用。主机端
负责屏幕采集和视频编码，iOS 客户端负责发现主机、完成配对、接收画面串流，并
将触控或手柄输入回传给主机。

## 主要特性

- **iPhone / iPad 客户端**，支持在局域网内接收 PC 屏幕串流。
- **低延迟串流**，基于 Moonlight/Sunshine 协议栈。
- **主机发现与配对**，复用 Moonlight 兼容连接流程。
- **触控与手柄输入**，支持对主机进行远程交互。
- **横屏投屏界面**，面向屏幕镜像场景优化。
- **多语言界面**，支持语言选择和 RevoMirror 专用提示文案。
- **应用内法律文件入口**，包含用户协议、隐私政策和 GPLv3 协议说明。

## 工作原理

RevoMirror-iOS 保留了 Moonlight 客户端的核心架构：

- 通过 mDNS 或手动地址添加发现主机。
- 通过配对和证书机制建立可信连接。
- 通过 Moonlight 兼容 HTTP API 发起应用/会话启动请求。
- 通过 `moonlight-common` 接收低延迟视频串流。
- 回传触控、手柄、键盘和鼠标输入。

在此基础上，RevoMirror-iOS 将原有偏游戏库的客户端体验调整为面向投屏的体验。
用户选择并配对主机后，应用可按 RevoMirror 默认配置直接进入串流流程，例如设备
屏幕分辨率、60 FPS、绝对触控模式以及 PC 端播放音频。

## 平台支持

| 角色 | iPhone | iPad | Apple TV |
|------|:------:|:----:|:--------:|
| RevoMirror-iOS 客户端 | 支持 | 支持 | RevoMirror-iOS 暂不面向 Apple TV |

**主机要求：** 需要 RevoMirror-PC 或 Sunshine 等 Moonlight 兼容主机，并与
iOS 设备处于同一局域网或同一网段。

## 系统要求

### iOS 客户端

- iOS/iPadOS 13.0 或更高版本。
- 支持硬件视频解码的 iPhone 或 iPad。
- 需要授予本地网络访问权限。
- 建议使用 5 GHz Wi-Fi 或稳定的局域网连接。

### 主机端

- RevoMirror-PC 或 Sunshine 兼容主机。
- 建议支持硬件视频编码，以获得更低延迟。
- 主机与 iOS 设备需处于同一局域网或同一网段。

## 快速开始

1. 在 PC 上安装并运行 RevoMirror-PC 或其他 Moonlight 兼容主机。
2. 将 PC 与 iOS 设备连接到同一局域网或同一网段。
3. 在 iOS 设备上构建并安装 RevoMirror-iOS。
4. 打开 App，自动发现或手动添加主机，然后完成配对。
5. 从 iOS 客户端开始投屏。

## 编译构建

1. 安装 Xcode。
2. 克隆本仓库并包含子模块，或在克隆后初始化子模块。
3. 使用 Xcode 打开 `RevoMirror_iOS/RevoMirror.xcodeproj`。
4. 选择 `RevoMirror` Target。
5. 配置 Apple Developer Team 签名。
6. 在真实 iPhone 或 iPad 设备上构建并运行。


关于原 Moonlight iOS 文件的修改摘要，请参见
[`CHANGES.md`](CHANGES.md)。

## 许可证

RevoMirror-iOS 遵循 **GNU 通用公共许可证 v3.0（GPL-3.0）** 分发，与原始
Moonlight iOS/tvOS 项目的许可证保持一致。

完整许可证文本请参见 [LICENSE](./LICENSE)。

## 致谢与声明

RevoMirror-iOS 基于以下优秀开源项目构建：

- **[Moonlight iOS/tvOS](https://github.com/moonlight-stream/moonlight-ios)** -
  面向 iOS 和 tvOS 的开源 Moonlight 客户端，遵循 GPL-3.0 许可证。
- **[moonlight-common-c](https://github.com/moonlight-stream/moonlight-common-c)** -
  Moonlight 通用串流客户端库。
- **[Sunshine](https://github.com/LizardByte/Sunshine)** - Moonlight 兼容的开源
  串流主机。

本仓库保留了原始项目的版权和许可证声明。
