# 北京时间任务栏时钟

Chunson Beijing Clock：贴合 Windows 主屏横向任务栏的独立北京时间小组件。

[下载 Windows x64 便携包](https://github.com/chunson-studio/beijing-clock/releases/latest/download/BeijingClock-Windows-x64.zip)

## 使用

1. 解压下载的 ZIP，保留文件在一个固定目录。
2. 双击 `BeijingClock.exe`。
3. 左键拖动调整位置；右键可恢复默认位置或退出。

固定显示 UTC+8 的时间、日期和星期，启动不联网，也不修改系统时区。支持系统深浅色、嫩芽图标和鼠标悬停动画。全屏或任务栏隐藏时暂时隐藏，返回后恢复显示。

它是贴合任务栏的独立窗口，适用于 Windows x64 桌面和主屏横向任务栏。使用 Windows 的 .NET Framework/WPF 运行环境，不需要椿生空间管理器。副屏、竖向任务栏及不同系统版本的实际布局请自行确认。

如需桌面快捷方式，可右键 `BeijingClock.exe`，选择“发送到 → 桌面快捷方式”。

## 开机启动

在解压目录打开 Windows PowerShell，按需执行：

```powershell
powershell -NoProfile -File .\Set-ClockStartup.ps1
```

取消开机启动：

```powershell
powershell -NoProfile -File .\Set-ClockStartup.ps1 -Disable
```

程序不会自动启用开机启动。系统原时钟是否显示，由你在 Windows 设置里选择。

## 从源码构建

在本目录使用 Windows PowerShell：

```powershell
powershell -NoProfile -File .\Build-Clock.ps1 -OutputPath .\dist\BeijingClock.exe -Check
```

构建使用 Windows 的 .NET Framework x64 C# 编译器及 WPF 程序集。`-Check` 只验证 UTC+8、跨日、单实例和隔离窗口规则，不启动正常时钟或修改任务栏设置。结果写入输出目录下的 `evidence/checks.txt`。

## 脚本与源码索引

| 文件 | 用途 |
| --- | --- |
| `TaskbarClock.cs` | 时钟界面、UTC+8、拖动位置和生命周期 |
| `Native.cs` | Windows 窗口与任务栏接口 |
| `ClockVisibility.cs` | 全屏判断、隐藏后恢复和窗口位置 |
| `ClockChecks.cs` | 隔离验证 |
| `Build-Clock.ps1` | 构建；可用 `-OutputPath` 指定新产物，`-Check` 执行隔离验证 |
| `Start-Clock.ps1` | 启动本目录的 `BeijingClock.exe` |
| `Stop-Clock.ps1` | 只停止本目录的时钟，并等待退出 |
| `Set-ClockStartup.ps1` | 显式启用或取消当前用户的开机启动 |
| `Read-ClockStatus.ps1` | 只读检查本目录时钟的进程和窗口状态 |
| `Inspect-Taskbar.ps1` | 按需保存本机任务栏信息和截图，供本地排错 |

位置保存在 `%LOCALAPPDATA%\ChunsonWidgets\position.txt`，只在拖动或恢复默认位置时更新。与椿生空间内置的同款时钟共用单实例和位置，重复启动不会创建第二个时钟。

诊断截图、位置文件和个人运行记录不属于公开源码或发布包。离线检查通过不等于已验证你的全屏、自动隐藏或下次登录效果。

## 许可

[MIT](LICENSE.txt)，允许使用、修改和商用，保留许可声明。
