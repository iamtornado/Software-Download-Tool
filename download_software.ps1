# Set encoding and error handling
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = 'Stop'

# Script introduction
Write-Host @"

====================== Software Download Tool ======================
This script will:
1. Download common software installers for offline installation
2. Create organized folders for each software
3. Save all installers in the Downloads\SoftwarePackages directory
4. Generate detailed log file for the process

Software list:
- QQ
- 微信
- 企业微信
- 网易灵犀办公
- 7-Zip
- 搜狗拼音输入法
- 搜狗五笔输入法
- Microsoft Edge
- Microsoft Edge WebView2 Runtime
- 全时云会议软件
- 钉钉
- Microsoft Visual C++ Redistributable 2015-2022 (x86/x64)

================================================================

"@ -ForegroundColor Cyan

# Create statistics hashtable
$stats = @{
    Successful = @()
    Failed = @()
}

# Function to get software version from winget
function Get-SoftwareVersion {
    param (
        [string]$WingetId
    )
    try {
        $wingetInfo = winget show $WingetId --accept-source-agreements
        $versionLine = $wingetInfo | Where-Object { $_ -match 'Version:|版本:' }
        if ($versionLine) {
            return ($versionLine -split ':\s*')[1].Trim()
        }
        return "Version not found"
    }
    catch {
        return "Version check failed"
    }
}

# Create log directory
$logRoot = Join-Path $env:TEMP "IT_Service"
if (-not (Test-Path $logRoot)) {
    New-Item -ItemType Directory -Path $logRoot -Force | Out-Null
}

# Start logging
$logFile = Join-Path $logRoot ("software_download_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".log")
Start-Transcript -Path $logFile -Force

# Display basic information
Write-Host "Software download script starting..."
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)"
Write-Host "Log file location: $logFile"

# Check PowerShell version
$requiredVersion = "7.4.6"
if ($PSVersionTable.PSVersion -lt [Version]$requiredVersion) {
    Write-Error "PowerShell $requiredVersion or higher is required"
    exit 1
}

# Get the actual download folder location
$shell = New-Object -ComObject Shell.Application
$downloads = $shell.NameSpace('shell:Downloads').Self.Path

# Define configuration parameters
$config = @{
    MaxRetries = 3
    RetryDelaySeconds = 3
    TimeoutSeconds = 300
    DownloadRoot = Join-Path $downloads 'SoftwarePackages'
    SkipExisting = 1  # Added: 1 means skip if file exists, 0 means always download
}

# Define software list to download
$software = @(
    @{
        Name = "QQ"
        Id = "Tencent.QQ.NT"
        FileName = "QQ.exe"
    },
    @{
        Name = "WeChat"
        Id = "Tencent.WeChat"
        FileName = "WeChatSetup.exe"
    },
    @{
        Name = "企业微信"
        Id = "Tencent.WeCom"
        FileName = "WeCom.exe"
    },
    @{
        Name = "网易灵犀办公"
        Id = "NetEase.Lingxi"
        FileName = "lingxi_win_x64.exe"
    },
    @{
        Name = "7-Zip"
        Id = "7zip.7zip"
        FileName = "7zip.exe"
    },
    @{
        Name = "搜狗拼音输入法"
        Id = "Sogou.SogouInput"
        FileName = "sogou_pinyin.exe"
    },
    @{
        Name = "搜狗五笔输入法"
        Id = "Sogou.SogouWBInput"
        FileName = "sogou_wubi.exe"
    },
    @{
        Name = "Microsoft Edge"
        Id = "Microsoft.Edge"
        FileName = "MicrosoftEdgeEnterpriseX64.msi"
    },
    @{
        Name = "Microsoft Edge WebView2 Runtime"
        Id = "Microsoft.EdgeWebView2Runtime"
        FileName = "MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
    },
    @{
        Name = "全时云会议软件"
        DirectUrl = "https://dle.quanshi.com/onemeeting/download/v2/G-Net_MeetNow_Setup.exe"
        FileName = "G-Net_MeetNow_Setup.exe"
    }
    # @{
    #     Name = "DingTalk"
    #     Id = "Alibaba.DingTalk"
    #     FileName = "DingTalk_Setup.exe"
    # }
)

# Special handling for Visual C++ Redistributable
$vcredist = @(
    @{
        Name = "VC_Redist_x64_VC++2015-2022(64bit)"
        Url = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        FileName = "VC_redist.x64.exe"
    },
    @{
        Name = "VC_Redist_x86_VC++2015-2022(32bit)"
        Url = "https://aka.ms/vs/17/release/vc_redist.x86.exe"
        FileName = "VC_redist.x86.exe"
    }
)

# Create download root directory
if (-not (Test-Path $config.DownloadRoot)) {
    Write-Host "Download directory does not exist, creating: $($config.DownloadRoot)" -ForegroundColor Yellow
    try {
        New-Item -ItemType Directory -Path $config.DownloadRoot -Force | Out-Null
        Write-Host "Successfully created download directory" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create download directory: $_"
        exit 1
    }
}
else {
    Write-Host "Using existing download directory: $($config.DownloadRoot)" -ForegroundColor Green
}

# Verify downloaded file
function Test-DownloadedFile {
    param (
        [string]$FilePath,
        [string]$Name
    )

    if (Test-Path $FilePath) {
        $fileSize = (Get-Item $FilePath).Length
        if ($fileSize -eq 0) {
            Write-Error "$Name download failed: File size is 0"
            Remove-Item $FilePath
            return $false
        }
        return $true
    }
    return $false
}

# Generic file download function
function Invoke-FileDownload {
    param (
        [string]$Url,
        [string]$OutputPath,
        [string]$Name
    )

    # Check if file exists and skip if configured
    if ($config.SkipExisting -eq 1 -and (Test-Path $OutputPath)) {
        $fileSize = (Get-Item $OutputPath).Length
        if ($fileSize -gt 0) {
            Write-Host "File already exists and is valid, skipping download: $OutputPath" -ForegroundColor Yellow
            return $true
        }
        else {
            Write-Host "Existing file is empty, will download again: $OutputPath" -ForegroundColor Yellow
            Remove-Item $OutputPath
        }
    }

    $retryCount = 0
    do {
        try {
            Write-Host "Downloading $Name..."
            
            # Enable progress bar display
            $ProgressPreference = 'Continue'
            
            # Use Invoke-WebRequest to download file
            Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing

            if (Test-DownloadedFile -FilePath $OutputPath -Name $Name) {
                Write-Host "Download completed: $Name" -ForegroundColor Green
                return $true
            }
        }
        catch {
            $retryCount++
            if ($retryCount -eq $config.MaxRetries) {
                Write-Error ("Failed to download " + $Name + ": " + $_.Exception.Message)
                return $false
            }
            Write-Warning "Download failed, retrying in $($config.RetryDelaySeconds) seconds ($retryCount/$($config.MaxRetries))..."
            Start-Sleep -Seconds $config.RetryDelaySeconds
        }
    } while ($retryCount -lt $config.MaxRetries)
}

# Download regular software function
function Get-Software {
    param (
        [string]$Name,
        [string]$WingetId,
        [string]$FileName,
        [string]$DirectUrl
    )

    Write-Host "`nProcessing $Name..." -ForegroundColor Cyan
    
    # Create software-specific directory
    $softwareDir = Join-Path $config.DownloadRoot $Name
    if (-not (Test-Path $softwareDir)) {
        New-Item -ItemType Directory -Path $softwareDir | Out-Null
    }

    try {
        if ($DirectUrl) {
            # Direct URL download
            Write-Host "Using direct download URL for $Name"
            $outputPath = Join-Path $softwareDir $FileName
            
            if (Invoke-FileDownload -Url $DirectUrl -OutputPath $outputPath -Name $Name) {
                $stats.Successful += @{
                    Name = $Name
                    Path = $outputPath
                    Version = "From direct URL"
                }
            } else {
                $stats.Failed += $Name
            }
            return
        }

        # Get software version
        $version = Get-SoftwareVersion -WingetId $WingetId

        Write-Host "Querying winget for $WingetId information..."
        
        # Get complete winget output for diagnostics
        $allOutput = winget show $WingetId --accept-source-agreements
        Write-Host "Winget complete output:" -ForegroundColor Yellow
        $allOutput | ForEach-Object { Write-Host $_ }

        # Try to get download URL
        $info = $allOutput | Where-Object { $_ -match '安装程序 URL：\s*(.+)|Installer URL:\s*(.+)' }
        if ($info) {
            $url = if ($matches[1]) { $matches[1].Trim() } else { $matches[2].Trim() }
            Write-Host "Found download URL: $url" -ForegroundColor Green
            
            if ($url) {
                # Use custom filename if provided, otherwise use URL filename
                $outputFileName = if ($FileName) { $FileName } else { Split-Path $url -Leaf }
                $outputPath = Join-Path $softwareDir $outputFileName
                Write-Host "Download path: $outputPath"

                # Download file
                if (Invoke-FileDownload -Url $url -OutputPath $outputPath -Name $Name) {
                    $stats.Successful += @{
                        Name = $Name
                        Path = $outputPath
                        Version = $version
                    }
                } else {
                    $stats.Failed += $Name
                }
            }
        }
        else {
            Write-Warning "Could not get download link for $Name"
            Write-Host "Please check if Winget ID is correct: $WingetId"
        }
    }
    catch {
        $stats.Failed += $Name
        Write-Error ("Error processing " + $Name + ": " + $_.Exception.Message)
        Write-Host "Error details:" -ForegroundColor Red
        $_.Exception | Format-List -Force
    }
}

# Download VC++ Redistributable function
function Get-VCRedist {
    param (
        [string]$Name,
        [string]$Url,
        [string]$CustomFileName
    )

    Write-Host "`nProcessing $Name..." -ForegroundColor Cyan
    
    # Create VC++-specific directory
    $vcDir = Join-Path $config.DownloadRoot $Name
    if (-not (Test-Path $vcDir)) {
        New-Item -ItemType Directory -Path $vcDir | Out-Null
    }

    try {
        $fileName = if ($CustomFileName) {
            $CustomFileName
        } else {
            Split-Path $Url -Leaf
        }
        $outputPath = Join-Path $vcDir $fileName

        # Download file
        Invoke-FileDownload -Url $Url -OutputPath $outputPath -Name $Name
    }
    catch {
        Write-Error ("Error processing " + $Name + ": " + $_.Exception.Message)
    }
}

# Main execution logic
Write-Host "`nStarting software downloads..." -ForegroundColor Yellow

# Download regular software
foreach ($item in $software) {
    if ($item.DirectUrl) {
        Get-Software -Name $item.Name -DirectUrl $item.DirectUrl -FileName $item.FileName
    } else {
        Get-Software -Name $item.Name -WingetId $item.Id -FileName $item.FileName
    }
}

# Download VC++ Redistributable
foreach ($item in $vcredist) {
    Get-VCRedist -Name $item.Name -Url $item.Url -CustomFileName $item.FileName
}

# After all downloads complete, show statistics
Write-Host "`n================= Download Statistics =================" -ForegroundColor Green

# Create custom objects for successful downloads
$successResults = $stats.Successful | ForEach-Object {
    [PSCustomObject]@{
        Name = $_.Name
        Version = $_.Version
        Path = $_.Path
    }
}

# Display successful downloads in table format
Write-Host "`nSuccessfully downloaded software:" -ForegroundColor Green
$successResults | Format-Table -AutoSize -Wrap

# Display failed downloads if any
if ($stats.Failed.Count -gt 0) {
    Write-Host "`nFailed downloads:" -ForegroundColor Red
    $stats.Failed | ForEach-Object { Write-Host "- $_" }
}

Write-Host "`nSummary:"
Write-Host "Total successful: $($stats.Successful.Count)"
Write-Host "Total failed: $($stats.Failed.Count)"
Write-Host "`n==================================================" -ForegroundColor Green

# Stop logging at script end
Stop-Transcript 