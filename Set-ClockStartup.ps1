param([switch]$Disable)
$ErrorActionPreference='Stop'
$startup=[Environment]::GetFolderPath('Startup')
$linkPath=Join-Path $startup 'Chun Beijing Clock.lnk'
if($Disable){
 if(Test-Path -LiteralPath $linkPath){Remove-Item -LiteralPath $linkPath}
 Write-Output 'Startup disabled.'
 return
}
$target=Join-Path $PSScriptRoot 'BeijingClock.exe'
if(!(Test-Path -LiteralPath $target)){throw 'Build BeijingClock.exe first.'}
$shell=New-Object -ComObject WScript.Shell
$link=$shell.CreateShortcut($linkPath)
$link.TargetPath=$target
$link.WorkingDirectory=$PSScriptRoot
$link.Description='北京时间任务栏卡片'
$link.Save()
$verify=$shell.CreateShortcut($linkPath)
if($verify.TargetPath -ne $target){throw 'Startup shortcut verification failed.'}
Write-Output $linkPath
