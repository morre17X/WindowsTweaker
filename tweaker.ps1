# tweaker.ps1 - Windows Tweaker Style Chris Titus Tech
Clear-Host

# Verifica Admin
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "┌────────────────────────────────────────────────────────────┐" -ForegroundColor Red
    Write-Host "│  ERROR: Richiedi privilegi amministrativi!                  │" -ForegroundColor Red
    Write-Host "└────────────────────────────────────────────────────────────┘" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}

function Show-Menu {
    Clear-Host
    Write-Host "┌────────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│                 WINDOWS TWEAKER v3.0                        │" -ForegroundColor Cyan
    Write-Host "│                      by morre                              │" -ForegroundColor Gray
    Write-Host "├────────────────────────────────────────────────────────────┤" -ForegroundColor Cyan
    Write-Host "│         Ottimizza Windows - Privacy - Performance          │" -ForegroundColor White
    Write-Host "└────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  ┌─ [ LIVELLI DI TWEAK ] ─────────────────────────────┐" -ForegroundColor Yellow
    Write-Host "  │                                                      │" -ForegroundColor DarkGray
    Write-Host "  │     [1]  MINIMAL                                    │" -ForegroundColor Green
    Write-Host "  │          - Disabilita Telemetria                    │" -ForegroundColor DarkGray
    Write-Host "  │          - Disabilita Animazioni                    │" -ForegroundColor DarkGray
    Write-Host "  │          - Abilita UAC                              │" -ForegroundColor DarkGray
    Write-Host "  │                                                      │" -ForegroundColor DarkGray
    Write-Host "  │     [2]  MEDIUM                                     │" -ForegroundColor Cyan
    Write-Host "  │          - Tutto MINIMAL +                          │" -ForegroundColor DarkGray
    Write-Host "  │          - Disabilita Cortana                       │" -ForegroundColor DarkGray
    Write-Host "  │          - Disabilita Trasparenze                   │" -ForegroundColor DarkGray
    Write-Host "  │          - Piano High Performance                   │" -ForegroundColor DarkGray
    Write-Host "  │                                                      │" -ForegroundColor DarkGray
    Write-Host "  │     [3]  EXPERT                                     │" -ForegroundColor Magenta
    Write-Host "  │          - Tutto MEDIUM +                           │" -ForegroundColor DarkGray
    Write-Host "  │          - Disabilita SMB1                          │" -ForegroundColor DarkGray
    Write-Host "  │          - Disabilita Servizi Pesanti               │" -ForegroundColor DarkGray
    Write-Host "  │                                                      │" -ForegroundColor DarkGray
    Write-Host "  ├─ [ UTILITIES ] ─────────────────────────────────────┤" -ForegroundColor Yellow
    Write-Host "  │                                                      │" -ForegroundColor DarkGray
    Write-Host "  │     [4]  Verifica Stato                             │" -ForegroundColor White
    Write-Host "  │     [5]  Backup Registro                            │" -ForegroundColor White
    Write-Host "  │     [0]  EXIT                                       │" -ForegroundColor Red
    Write-Host "  │                                                      │" -ForegroundColor DarkGray
    Write-Host "  └──────────────────────────────────────────────────────┘" -ForegroundColor DarkGray
    Write-Host ""
}

function Apply-Minimal {
    Clear-Host
    Write-Host "┌─ [ MINIMAL TWEAKS ] ─────────────────────────────────┐" -ForegroundColor Green
    Write-Host "│                                                        │" -ForegroundColor DarkGray
    Write-Host "│  Disabilito Telemetria..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                        " -ForegroundColor DarkGray
    Write-Host "│  Disabilito Animazioni..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                        " -ForegroundColor DarkGray
    Write-Host "│  Abilito UAC..." -ForegroundColor White
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                        " -ForegroundColor DarkGray
    Write-Host "│  COMPLETATO!                                          " -ForegroundColor Green
    Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Green
    Read-Host "Premi Enter"
}

function Apply-Medium {
    Clear-Host
    Write-Host "┌─ [ MEDIUM TWEAKS ] ───────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│                                                         │" -ForegroundColor DarkGray
    Write-Host "│  Disabilito Telemetria..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                         " -ForegroundColor DarkGray
    Write-Host "│  Disabilito Animazioni..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                         " -ForegroundColor DarkGray
    Write-Host "│  Abilito UAC..." -ForegroundColor White
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                         " -ForegroundColor DarkGray
    Write-Host "│  Disabilito Cortana..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                         " -ForegroundColor DarkGray
    Write-Host "│  Disabilito Trasparenze..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Force
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                         " -ForegroundColor DarkGray
    Write-Host "│  Piano High Performance..." -ForegroundColor White
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
    Write-Host "│    OK" -ForegroundColor Green
    Write-Host "│                                                         " -ForegroundColor DarkGray
    Write-Host "│  COMPLETATO!                                          " -ForegroundColor Green
    Write-Host "└─────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    Read-Host "Premi Enter"
}

function Apply-Expert {
    Clear-Host
    Write-Host "┌─ [ EXPERT TWEAKS ] ───────────────────────────────────┐" -ForegroundColor Magenta
    Write-Host "│                                                         │" -ForegroundColor DarkGray
    Write-Host "│  ATTENZIONE: Tweak per utenti esperti                   │" -ForegroundColor Red
    Write-Host "│                                                         │" -ForegroundColor DarkGray
    Write-Host "└─────────────────────────────────────────────────────────┘" -ForegroundColor Magenta
    $confirm = Read-Host "Sei sicuro? (S/N)"
    if ($confirm -eq "S" -or $confirm -eq "s") {
        Write-Host ""
        Write-Host "│  Backup in corso..." -ForegroundColor White
        $backup = "$env:USERPROFILE\Desktop\backup.reg"
        Start-Process reg.exe -ArgumentList "export HKLM `"$backup`"" -Wait -NoNewWindow
        Write-Host "│    Backup salvato sul Desktop" -ForegroundColor Green
        
        Write-Host "│  Applico tweak..." -ForegroundColor White
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Force
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart -ErrorAction SilentlyContinue
        Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
        
        Write-Host "│  COMPLETATO! Riavvia il PC" -ForegroundColor Green
    }
    Read-Host "Premi Enter"
}

function Show-Status {
    Clear-Host
    Write-Host "┌─ [ STATO CONFIGURAZIONE ] ────────────────────────────┐" -ForegroundColor Yellow
    
    $t = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
    if ($t.AllowTelemetry -eq 0) { Write-Host "│  OK Telemetria: Disabilitata" -ForegroundColor Green }
    else { Write-Host "│  NO Telemetria: Attiva" -ForegroundColor Red }
    
    $c = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
    if ($c.AllowCortana -eq 0) { Write-Host "│  OK Cortana: Disabilitata" -ForegroundColor Green }
    else { Write-Host "│  NO Cortana: Attiva" -ForegroundColor Red }
    
    Write-Host "└─────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
    Read-Host "Premi Enter"
}

# MAIN
do {
    Show-Menu
    $choice = Read-Host "  Seleziona opzione"
    switch ($choice) {
        "1" { Apply-Minimal }
        "2" { Apply-Medium }
        "3" { Apply-Expert }
        "4" { Show-Status }
        "5" { 
            Clear-Host
            Write-Host "Backup in corso..."
            $backup = "$env:USERPROFILE\Desktop\backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
            Start-Process reg.exe -ArgumentList "export HKLM `"$backup`"" -Wait -NoNewWindow
            Write-Host "Backup salvato sul Desktop"
            Read-Host "Premi Enter"
        }
        "0" { exit }
        default { Write-Host "Opzione non valida!"; Start-Sleep 1 }
    }
} while ($true)
