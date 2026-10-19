param([string]$OutputDirectory = (Join-Path $PSScriptRoot 'evidence'))
$ErrorActionPreference = 'Stop'
Add-Type -Path (Join-Path $PSScriptRoot 'Native.cs')
[Native]::Dpi()
$h = [Native]::FindWindow('Shell_TrayWnd',$null)
if ($h -eq [IntPtr]::Zero) { throw 'Taskbar not found' }
$rows = [Collections.Generic.List[object]]::new()
$read = {param($handle)
 $rect = [Native+Rect]::new()
 [void][Native]::GetWindowRect($handle,[ref]$rect)
 $rows.Add([pscustomobject]@{Handle=$handle.ToInt64();Class=[Native]::ClassName($handle);Visible=[Native]::IsWindowVisible($handle);Left=$rect.Left;Top=$rect.Top;Width=$rect.Width;Height=$rect.Height})
}
& $read $h
$cb = [Native+Callback]{param($handle,$parameter) & $read $handle; return $true}
[void][Native]::EnumChildWindows($h,$cb,[IntPtr]::Zero)
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$rows | ConvertTo-Json | Set-Content (Join-Path $OutputDirectory 'taskbar-windows.json') -Encoding utf8
$rows | ConvertTo-Json
Add-Type -AssemblyName System.Drawing
$r = $rows[0]
$bmp = [Drawing.Bitmap]::new($r.Width,$r.Height)
$g = [Drawing.Graphics]::FromImage($bmp)
try { $g.CopyFromScreen($r.Left,$r.Top,0,0,$bmp.Size); $bmp.Save((Join-Path $OutputDirectory 'taskbar.png')) } finally { $g.Dispose(); $bmp.Dispose() }
