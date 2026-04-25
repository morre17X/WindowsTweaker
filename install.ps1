# install.ps1 - Script di installazione del tweaker
param(
    [switch]$Uninstall
)

$RepoUrl = "https://raw.githubusercontent.com/morre17X/WindowsTweaker/main"
$InstallPath = "$env:USERPROFILE\WindowsTweaker"

if ($Uninstall) {
    Write-Host "┌────────────────────────────────────────────────────────────┐" -ForegroundColor Yellow
    Write-Host "│              Rimozione Windows Tweaker...                   │" -ForegroundColor Yellow
    Write-Host "└────────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
    Remove-Item -Path $InstallPath -Recurse -Force -ErrorAction SilentlyContinue
    
    # Rimuovi alias dal profilo
    $ProfilePath = $PROFILE.CurrentUserAllHosts
    if (Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath | Where-Object { $_ -notlike "*WindowsTweaker*" }
        $content | Set-Content $ProfilePath
    }
    
    Write-Host ""
    Write-Host "  ✅ Tweaker rimosso con successo!" -ForegroundColor Green
    Read-Host "  Premi Enter per uscire"
    exit
}

Write-Host "┌────────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│              Installazione Windows Tweaker...               │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""

# Crea directory
Write-Host "  📁 Creazione cartella di installazione..." -ForegroundColor White
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
Write-Host "    ✅ Fatto" -ForegroundColor Green

# Scarica i moduli
$files = @("tweaker.ps1", "config.json", "modules/privacy.ps1", "modules/performance.ps1", "modules/security.ps1")
$success = $true

foreach ($file in $files) {
    $url = "$RepoUrl/$file"
    $dest = "$InstallPath/$file"
    $dir = Split-Path $dest -Parent
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    
    Write-Host "  📥 Download: $file..." -ForegroundColor White
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
        Write-Host "    ✅ Completato" -ForegroundColor Green
    } catch {
        Write-Host "    ⚠️ File non trovato (continua comunque)" -ForegroundColor Yellow
        $success = $false
    }
}

# Aggiunge alias a PowerShell Profile
Write-Host ""
Write-Host "  ⚙️ Configurazione profilo PowerShell..." -ForegroundColor White

$ProfileLine = "function tweak { & `"$InstallPath\tweaker.ps1`" `$args }"
$ProfilePath = $PROFILE.CurrentUserAllHosts

try {
    if (Test-Path $ProfilePath) {
        $currentContent = Get-Content $ProfilePath -ErrorAction SilentlyContinue
        if ($currentContent -notcontains $ProfileLine) {
            Add-Content -Path $ProfilePath -Value "`n# Windows Tweaker`n$ProfileLine"
            Write-Host "    ✅ Alias aggiunto al profilo" -ForegroundColor Green
        } else {
            Write-Host "    ℹ️ Alias già presente" -ForegroundColor Cyan
        }
    } else {
        New-Item -Path (Split-Path $ProfilePath -Parent) -ItemType Directory -Force | Out-Null
        Set-Content -Path $ProfilePath -Value "# Windows Tweaker`n$ProfileLine"
        Write-Host "    ✅ Profilo creato e alias aggiunto" -ForegroundColor Green
    }
} catch {
    Write-Host "    ⚠️ Non è stato possibile modificare il profilo" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────────┐" -ForegroundColor Green
Write-Host "│              ✅ INSTALLAZIONE COMPLETATA!                   │" -ForegroundColor Green
Write-Host "└────────────────────────────────────────────────────────────┘" -ForegroundColor Green
Write-Host ""
Write-Host "  🚀 Avvio del menu in corso..." -ForegroundColor Cyan
Write-Host ""

Start-Sleep -Seconds 2

# 🚀 AVVIA SUBITO IL MENU
if (Test-Path "$InstallPath\tweaker.ps1") {
    & "$InstallPath\tweaker.ps1"
} else {
    Write-Host "  ⚠️ File tweaker.ps1 non trovato, scarico direttamente..." -ForegroundColor Yellow
    $tempScript = [System.IO.Path]::GetTempFileName() + ".ps1"
    Invoke-WebRequest -Uri "$RepoUrl/tweaker.ps1" -OutFile $tempScript -UseBasicParsing
    & $tempScript
}
