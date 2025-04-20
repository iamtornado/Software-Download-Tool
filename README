<div style="text-align: right; margin-bottom: 20px;">
  <a href="README_zh.md" style="background-color: #4CAF50; color: white; padding: 8px 16px; text-align: center; text-decoration: none; display: inline-block; border-radius: 4px;">中文</a>
</div>

# Software Download Tool

A PowerShell script for downloading common software installers for offline installation. This tool uses winget to fetch download URLs and automatically downloads the latest versions of specified software, making it easier to maintain an offline software repository.

## 🚀 Features

- ✨ Downloads software installers using winget
- 📁 Creates organized folders for each software
- 📥 Customizable file names for downloads
- 📊 Shows download progress
- 📝 Generates detailed log file
- 📈 Provides download statistics in table format
- 🔄 Automatic retry on failed downloads
- 🎯 Supports custom file naming
- 📦 Creates structured software package directory

## 📋 Prerequisites

- Windows 10/11;windows server 2016/2019/2022/2025
- PowerShell 5.1 or higher
- Winget package manager
- Internet connection
- Sufficient disk space in Downloads folder

## 🎯 Supported Software

### Communication
- QQ
- WeChat
- WeCom
- DingTalk

### Utilities
- 7-Zip
- Microsoft Edge
- 网易灵犀办公

### Input Methods
- 搜狗输入法
- 搜狗五笔输入法

### Runtime Components
- Microsoft Visual C++ Redistributable 2015-2022 (x86/x64)

## 💻 Usage

1. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/software-downloader.git
cd software-downloader
```

2. Run the script:
```powershell
.\download_software.ps1
```

3. Check the Downloads\SoftwarePackages directory for downloaded installers

## 📊 Output Example

```
================= Download Statistics =================

Successfully downloaded software:

Name           Version        Path
----           -------        ----
QQ             9.7.3         C:\Users\...\SoftwarePackages\QQ\QQ.exe
WeChat         3.9.0         C:\Users\...\SoftwarePackages\WeChat\WeChatSetup.exe
7-Zip          23.01         C:\Users\...\SoftwarePackages\7-Zip\7z.exe
Edge           121.0.2277.83 C:\Users\...\SoftwarePackages\Edge\MicrosoftEdge_X64.exe
DingTalk       7.0.50        C:\Users\...\SoftwarePackages\DingTalk\DingTalk.exe

Summary:
Total successful: 5
Total failed: 0
==================================================
```

## 📝 Log Files

Log files are automatically generated for each run:

- **Location**: `%TEMP%\IT_Service\software_download_YYYYMMDD_HHMMSS.log`
- **Format**: Plain text with timestamp for each operation
- **Content**: Includes all operations, errors, and download statistics

## ⚙️ Configuration

### Default Settings
```powershell
$config = @{
    MaxRetries = 3              # Maximum download retry attempts
    RetryDelaySeconds = 3       # Delay between retries
    TimeoutSeconds = 300        # Download timeout
    DownloadRoot = "..."        # Default download location
}
```

### Customization Options
- Modify software list in the script
- Customize file names for downloads
- Adjust retry and timeout settings
- Change download directory structure

## 🔍 Directory Structure

```
Downloads\SoftwarePackages\
├── QQ\
├── WeChat\
├── WeCom\
├── Lingxi\
├── 7-Zip\
├── Edge\
├── DingTalk\
├── SogouInput\
└── VCRedist\
    ├── x86\
    └── x64\
```

## 🛠️ Error Handling

The script includes comprehensive error handling:
- Download retry mechanism
- File integrity verification
- Detailed error logging
- Progress tracking
- Status reporting


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Documentation

- [Winget Documentation](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)
- [Windows Package Manager](https://github.com/microsoft/winget-cli)

## ⚠️ Notes

- Ensure you have necessary permissions for software distribution
- Keep the script updated with latest software IDs
- Check winget regularly for package ID changes
- Consider network bandwidth when downloading multiple packages

## 📞 Support

For support, please:
1. Check the log files for error details
2. Review the winget package IDs
3. Verify network connectivity
4. Contact repository maintainer if issues persist
5. send email to 1426693102@qq.com


## Author

- Name: iamtornado
- Website: https://github.com/iamtornado
- Email: 1426693102@qq.com
- My WeChat Qrcode:
![alt text](images/作者微信二维码.png)
- QQ group: 715152187
![alt text](images/AI发烧友QQ群二维码裁剪版.png)
- WeChat Official Account: AI发烧友
![alt text](images/AI发烧友公众号宣传图片.png)