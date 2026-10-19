$ErrorActionPreference='Stop'
Start-Process -FilePath (Join-Path $PSScriptRoot 'BeijingClock.exe') -WorkingDirectory $PSScriptRoot -WindowStyle Hidden
