[CmdletBinding()]
param([string]$OutputPath)
$ErrorActionPreference='Stop'
Add-Type -Path @((Join-Path $PSScriptRoot 'Native.cs'),(Join-Path $PSScriptRoot 'ClockVisibility.cs'))
Add-Type -AssemblyName System.Windows.Forms
[Native]::Dpi()
$target=Join-Path $PSScriptRoot 'BeijingClock.exe'
$processes=@(Get-Process -Name BeijingClock -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $target })
# PowerShell $null converts to an empty string for native string parameters.
$clockHandle=[Native]::FindWindow([System.Management.Automation.Language.NullString]::Value,'Chun Beijing Taskbar Clock')
$taskbarHandle=[Native]::FindWindow('Shell_TrayWnd',[System.Management.Automation.Language.NullString]::Value)
$clockRect=[Native+Rect]::new(); $taskbarRect=[Native+Rect]::new()
$clockFound=[Native]::GetWindowRect($clockHandle,[ref]$clockRect)
$taskbarFound=[Native]::GetWindowRect($taskbarHandle,[ref]$taskbarRect)
$foreground=[Native]::GetForegroundWindow()
$foregroundRect=[Native+Rect]::new();$frameFound=[Native]::VisibleFrame($foreground,[ref]$foregroundRect)
$screen=[Windows.Forms.Screen]::FromHandle($taskbarHandle).Bounds
$screenRect=[Native+Rect]::new();$screenRect.Left=$screen.Left;$screenRect.Top=$screen.Top;$screenRect.Right=$screen.Right;$screenRect.Bottom=$screen.Bottom
$result=[pscustomobject]@{
 timestamp=[DateTimeOffset]::Now.ToString('o')
 processes=@($processes | Select-Object Id,Responding,StartTime)
 clockHandle=$clockHandle.ToInt64(); windowFound=$clockFound
 windowVisible=[Native]::IsWindowVisible($clockHandle)
 minimized=[Native]::IsIconic($clockHandle)
 topmost=(([Native]::GetWindowLongPtrW($clockHandle,-20).ToInt64() -band 8) -ne 0)
 behindTaskbar=[ClockVisibility]::BehindTaskbar($clockHandle,$taskbarHandle)
 ownerHandle=[Native]::GetWindowLongPtrW($clockHandle,-8).ToInt64()
 foregroundClass=[Native]::ClassName($foreground); foregroundFrame=$foregroundRect; foregroundFrameFound=$frameFound
 foregroundFullscreen=[ClockVisibility]::ForegroundFullscreen($foreground,$clockHandle,$taskbarHandle,$screenRect)
 clockRect=$clockRect; taskbarRect=$taskbarRect
 withinTaskbar=($clockFound -and $taskbarFound -and $clockRect.Left -ge $taskbarRect.Left -and $clockRect.Right -le $taskbarRect.Right -and $clockRect.Top -ge $taskbarRect.Top -and $clockRect.Bottom -le $taskbarRect.Bottom)
 scope='Read-only process/window geometry; does not verify opacity, occlusion, rendered time or visual acceptance.'
}
$json=$result | ConvertTo-Json -Depth 6
if($OutputPath){
 $fullPath=[IO.Path]::GetFullPath($OutputPath)
 [void][IO.Directory]::CreateDirectory((Split-Path -Parent $fullPath))
 [IO.File]::WriteAllText($fullPath,$json,[Text.UTF8Encoding]::new($false))
}
$json
