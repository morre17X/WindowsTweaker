# tweaker.ps1 - Windows Tweaker (Versione Stabile)
Clear-Host

# Verifica Admin
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host "  ERRORE: ESEGUI POWERSHELL COME ADMINISTRATORE  " -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}

function Show-Header {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "         WINDOWS TWEAKER v3.0 - by morre          " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "       Ottimizza Windows - Privacy - Performance  " -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Apply-Minimal {
    Show-Header
    Write-Host "[ MINIMAL TWEAKS ]" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "  > Disabilito Telemetria..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host "  > Disabilito Animazioni..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host "  > Abilito UAC..." -ForegroundColor White
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "[COMPLETATO] Riavvia il PC per alcuni effetti" -ForegroundColor Green
    Read-Host "Premi Enter per continuare"
}

function Apply-Medium {
    Show-Header
    Write-Host "[ MEDIUM TWEAKS ]" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "  > Disabilito Telemetria..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host "  > Disabilito Animazioni..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host "  > Abilito UAC..." -ForegroundColor White
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host "  > Disabilito Cortana..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host "  > Disabilito Trasparenze..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host "  > Imposto Piano High Performance..." -ForegroundColor White
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
    Write-Host "    [OK]" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "[COMPLETATO] Riavvia il PC per completare" -ForegroundColor Green
    Read-Host "Premi Enter per continuare"
}

function Apply-Expert {
    Show-Header
    Write-Host "[ EXPERT TWEAKS ]" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "ATTENZIONE: Tweak per utenti esperti!" -ForegroundColor Red
    $confirm = Read-Host "Sei sicuro? (S/N)"
    
    if ($confirm -eq "S" -or $confirm -eq "s") {
        Write-Host ""
        Write-Host "  > Creazione backup di sicurezza..." -ForegroundColor White
        $backupPath = "$env:USERPROFILE\Desktop\WindowsTweaker_Backup.reg"
        Start-Process -FilePath "reg.exe" -ArgumentList "export HKLM `"$backupPath`"" -Wait -NoNewWindow
        Write-Host "    [OK] Backup salvato sul Desktop" -ForegroundColor Green
        
        Write-Host "  > Applico tweak MINIMAL + MEDIUM..." -ForegroundColor White
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Force
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        Write-Host "    [OK]" -ForegroundColor Green
        
        Write-Host "  > Disabilito SMB1 (sicurezza)..." -ForegroundColor White
        Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart -ErrorAction SilentlyContinue
        Write-Host "    [OK]" -ForegroundColor Green
        
        Write-Host "  > Disabilito SysMain (Superfetch)..." -ForegroundColor White
        Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "    [OK]" -ForegroundColor Green
        
        Write-Host "  > Disabilito Windows Search..." -ForegroundColor White
        Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "    [OK]" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "[COMPLETATO] RIAVVIA IL PC!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "[ANNULLATO]" -ForegroundColor Yellow
    }
    Read-Host "Premi Enter per continuare"
}

function Show-Status {
    Show-Header
    Write-Host "[ STATO CONFIGURAZIONE ]" -ForegroundColor Yellow
    Write-Host ""
    
    $telemetry = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
    if ($telemetry.AllowTelemetry -eq 0) {
        Write-Host "  [OK] Telemetria: DISABILITATA" -ForegroundColor Green
    } else {
        Write-Host "  [NO] Telemetria: ATTIVA" -ForegroundColor Red
    }
    
    $cortana = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
    if ($cortana.AllowCortana -eq 0) {
        Write-Host "  [OK] Cortana: DISABILITATA" -ForegroundColor Green
    } else {
        Write-Host "  [NO] Cortana: ATTIVA" -ForegroundColor Red
    }
    
    $uac = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -ErrorAction SilentlyContinue
    if ($uac.EnableLUA -eq 1) {
        Write-Host "  [OK] UAC: ATTIVO" -ForegroundColor Green
    } else {
        Write-Host "  [NO] UAC: DISABILITATO" -ForegroundColor Red
    }
    
    $transparency = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -ErrorAction SilentlyContinue
    if ($transparency.EnableTransparency -eq 0) {
        Write-Host "  [OK] Trasparenze: DISABILITATE" -ForegroundColor Green
    } else {
        Write-Host "  [NO] Trasparenze: ATTIVE" -ForegroundColor Red
    }
    
    Read-Host "Premi Enter per continuare"
}

function Backup-Registry {
    Show-Header
    Write-Host "[ BACKUP REGISTRO ]" -ForegroundColor Green
    Write-Host ""
    
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "$env:USERPROFILE\Desktop\Registry_Backup_$date.reg"
    Write-Host "  > Creazione backup in corso..." -ForegroundColor White
    Start-Process -FilePath "reg.exe" -ArgumentList "export HKLM `"$backupPath`"" -Wait -NoNewWindow
    Write-Host "  [OK] Backup salvato sul Desktop" -ForegroundColor Green
    
    Read-Host "Premi Enter per continuare"
}

do {
    Show-Header
    Write-Host "SELEZIONA UN'OPZIONE:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1]  MINIMAL - Tweak essenziali" -ForegroundColor Green
    Write-Host "  [2]  MEDIUM  - Bilanciato" -ForegroundColor Cyan
    Write-Host "  [3]  EXPERT  - Massima ottimizzazione" -ForegroundColor Magenta
    Write-Host "  [4]  STATO   - Verifica configurazione" -ForegroundColor White
    Write-Host "  [5]  BACKUP  - Backup del registro" -ForegroundColor White
    Write-Host "  [0]  EXIT    - Esci" -ForegroundColor Red
    Write-Host ""
    
    $choice = Read-Host "Inserisci il numero"
    
    switch ($choice) {
        "1" { Apply-Minimal }
        "2" { Apply-Medium }
        "3" { Apply-Expert }
        "4" { Show-Status }
        "5" { Backup-Registry }
        "0" {
            Write-Host ""
            Write-Host "Grazie per aver usato Windows Tweaker!" -ForegroundColor Green
            Write-Host "Arrivederci!" -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-Host ""
            Write-Host "[ERRORE] Opzione non valida!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($true)
