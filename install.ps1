# install.ps1
$RepoUrl = "https://raw.githubusercontent.com/morre17X/WindowsTweaker/main"
$InstallPath = "$env:USERPROFILE\WindowsTweaker"

Write-Host "Installazione Windows Tweaker..." -ForegroundColor Cyan

New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null

$url = "$RepoUrl/tweaker.ps1"
$dest = "$InstallPath/tweaker.ps1"
Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

Write-Host "Installazione completata! Avvio..." -ForegroundColor Green
Start-Sleep -Seconds 1

& "$InstallPath\tweaker.ps1"
