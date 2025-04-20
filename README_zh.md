<div style="text-align: right; margin-bottom: 20px;">
  <a href="README" style="background-color: #4CAF50; color: white; padding: 8px 16px; text-align: center; text-decoration: none; display: inline-block; border-radius: 4px;">English</a>
</div>

# 软件下载工具

一个PowerShell脚本，用于下载常用软件安装包以便离线安装。该工具使用winget获取下载链接，并自动下载指定软件的最新版本，便于维护离线软件库。

## 🚀 功能特点

- ✨ 使用winget下载软件安装包
- 📁 为每个软件创建有序的文件夹
- 📥 可自定义下载文件的名称
- 📊 显示下载进度
- 📝 生成详细日志文件
- 📈 以表格形式提供下载统计
- 🔄 下载失败自动重试
- 🎯 支持自定义文件命名
- 📦 创建结构化的软件包目录

## 📋 系统要求

- Windows 10/11; Windows Server 2016/2019/2022/2025
- PowerShell 5.1或更高版本
- Winget包管理器
- 网络连接
- 下载文件夹有足够磁盘空间

## 🎯 支持软件

### 通讯工具
- QQ
- 微信
- 企业微信
- 钉钉

### 实用工具
- 7-Zip
- Microsoft Edge
- 网易灵犀办公

### 输入法
- 搜狗输入法
- 搜狗五笔输入法

### 运行组件
- Microsoft Visual C++ Redistributable 2015-2022 (x86/x64)

## 💻 使用方法

1. 克隆本仓库:
```bash
git clone https://github.com/YOUR_USERNAME/software-downloader.git
cd software-downloader
```

2. 运行脚本:
```powershell
.\download_software.ps1
```

3. 在Downloads\SoftwarePackages目录中查看下载的安装包

## 📊 输出示例

```
================= 下载统计 =================

成功下载的软件:

名称           版本         路径
----           -------      ----
QQ             9.7.3        C:\Users\...\SoftwarePackages\QQ\QQ.exe
微信           3.9.0        C:\Users\...\SoftwarePackages\WeChat\WeChatSetup.exe
7-Zip          23.01        C:\Users\...\SoftwarePackages\7-Zip\7z.exe
Edge           121.0.2277.83 C:\Users\...\SoftwarePackages\Edge\MicrosoftEdge_X64.exe
钉钉           7.0.50       C:\Users\...\SoftwarePackages\DingTalk\DingTalk.exe

统计:
成功总数: 5
失败总数: 0
==========================================
```

## 📝 日志文件

每次运行会自动生成日志文件:

- **位置**: `%TEMP%\IT_Service\software_download_YYYYMMDD_HHMMSS.log`
- **格式**: 带时间戳的纯文本
- **内容**: 包含所有操作、错误和下载统计

## ⚙️ 配置

### 默认设置
```powershell
$config = @{
    MaxRetries = 3              # 最大重试次数
    RetryDelaySeconds = 3       # 重试间隔(秒)
    TimeoutSeconds = 300        # 下载超时时间
    DownloadRoot = "..."        # 默认下载位置
}
```

### 自定义选项
- 修改脚本中的软件列表
- 自定义下载文件名
- 调整重试和超时设置
- 更改下载目录结构

## 🔍 目录结构

```
Downloads\SoftwarePackages\
├── QQ\
├── 微信\
├── 企业微信\
├── 灵犀\
├── 7-Zip\
├── Edge\
├── 钉钉\
├── 搜狗输入法\
└── VCRedist\
    ├── x86\
    └── x64\
```

## 🛠️ 错误处理

脚本包含全面的错误处理机制:
- 下载重试机制
- 文件完整性验证
- 详细错误日志
- 进度跟踪
- 状态报告


## 📄 许可证

本项目采用 MIT 许可证。请查看 [LICENSE](LICENSE) 文件以获取更多信息。

## 🔗 相关文档

- [Winget文档](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [PowerShell文档](https://learn.microsoft.com/en-us/powershell/)
- [Windows包管理器](https://github.com/microsoft/winget-cli)

## ⚠️ 注意事项

- 确保您有软件分发的必要权限
- 保持脚本中的软件ID为最新
- 定期检查winget的包ID变更
- 下载多个软件包时考虑网络带宽

## 📞 支持

如需支持，请:
1. 检查日志文件获取错误详情
2. 检查winget包ID
3. 验证网络连接
4. 如问题持续，联系仓库维护者
5. 发送邮件至1426693102@qq.com

## 作者

- 名称: iamtornado
- 网站: https://github.com/iamtornado
- 邮箱: 1426693102@qq.com
- 我的微信二维码:
![alt text](images/作者微信二维码.png)
- QQ群: 715152187
![alt text](images/AI发烧友QQ群二维码裁剪版.png)
- 微信公众号: AI发烧友
![alt text](images/AI发烧友公众号宣传图片.png)