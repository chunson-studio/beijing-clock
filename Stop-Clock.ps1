$ErrorActionPreference='Stop'
$target=Join-Path $PSScriptRoot 'BeijingClock.exe'
foreach($clockProcess in @(Get-Process -Name BeijingClock -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $target })){
 try {
  if($clockProcess.HasExited){continue}
  # Retain the exact process handle and wait for EXE release before replacing it.
  $null=$clockProcess.Handle
  $clockProcess.Kill()
  if(!$clockProcess.WaitForExit(5000)){throw 'Clock did not exit; executable was not replaced.'}
 } finally {$clockProcess.Dispose()}
}
