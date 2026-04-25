# tweaker.ps1 - Windows Tweaker
Clear-Host

$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "ERROR: Run PowerShell as Administrator" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

function Show-Header {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "         WINDOWS TWEAKER v3.0 - by morre          " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Apply-Minimal {
    Show-Header
    Write-Host "[ MINIMAL TWEAKS ]" -ForegroundColor Green
    Write-Host ""
    Write-Host "  > Disabling Telemetry..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host "  > Disabling Animations..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host "  > Enabling UAC..." -ForegroundColor White
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host ""
    Write-Host "[DONE] Restart may be required" -ForegroundColor Green
    Read-Host "Press Enter"
}

function Apply-Medium {
    Show-Header
    Write-Host "[ MEDIUM TWEAKS ]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  > Disabling Telemetry..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host "  > Disabling Animations..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host "  > Enabling UAC..." -ForegroundColor White
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host "  > Disabling Cortana..." -ForegroundColor White
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host "  > Disabling Transparency..." -ForegroundColor White
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Force
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host "  > High Performance Power Plan..." -ForegroundColor White
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
    Write-Host "    [OK]" -ForegroundColor Green
    Write-Host ""
    Write-Host "[DONE] Restart required" -ForegroundColor Green
    Read-Host "Press Enter"
}

function Apply-Expert {
    Show-Header
    Write-Host "[ EXPERT TWEAKS ]" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "WARNING: Expert tweaks!" -ForegroundColor Red
    $confirm = Read-Host "Are you sure? (Y/N)"
    if ($confirm -eq "Y" -or $confirm -eq "y") {
        Write-Host ""
        Write-Host "  > Creating backup..." -ForegroundColor White
        $backupPath = "$env:USERPROFILE\Desktop\WindowsTweaker_Backup.reg"
        Start-Process -FilePath "reg.exe" -ArgumentList "export HKLM `"$backupPath`"" -Wait -NoNewWindow
        Write-Host "    [OK] Backup saved on Desktop" -ForegroundColor Green
        Write-Host "  > Applying Minimal + Medium..." -ForegroundColor White
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Force
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        Write-Host "    [OK]" -ForegroundColor Green
        Write-Host "  > Disabling SMB1..." -ForegroundColor White
        Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart -ErrorAction SilentlyContinue
        Write-Host "    [OK]" -ForegroundColor Green
        Write-Host "  > Disabling SysMain..." -ForegroundColor White
        Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "    [OK]" -ForegroundColor Green
        Write-Host "  > Disabling Windows Search..." -ForegroundColor White
        Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "    [OK]" -ForegroundColor Green
        Write-Host ""
        Write-Host "[DONE] REBOOT REQUIRED!" -ForegroundColor Green
    } else {
        Write-Host "[CANCELLED]" -ForegroundColor Yellow
    }
    Read-Host "Press Enter"
}

function Show-Status {
    Show-Header
    Write-Host "[ CONFIGURATION STATUS ]" -ForegroundColor Yellow
    Write-Host ""
    $telemetry = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
    if ($telemetry.AllowTelemetry -eq 0) { Write-Host "  [OK] Telemetry: DISABLED" -ForegroundColor Green }
    else { Write-Host "  [NO] Telemetry: ENABLED" -ForegroundColor Red }
    $cortana = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
    if ($cortana.AllowCortana -eq 0) { Write-Host "  [OK] Cortana: DISABLED" -ForegroundColor Green }
    else { Write-Host "  [NO] Cortana: ENABLED" -ForegroundColor Red }
    $uac = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -ErrorAction SilentlyContinue
    if ($uac.EnableLUA -eq 1) { Write-Host "  [OK] UAC: ENABLED" -ForegroundColor Green }
    else { Write-Host "  [NO] UAC: DISABLED" -ForegroundColor Red }
    Read-Host "Press Enter"
}

function Backup-Registry {
    Show-Header
    Write-Host "[ REGISTRY BACKUP ]" -ForegroundColor Green
    Write-Host ""
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "$env:USERPROFILE\Desktop\Registry_Backup_$date.reg"
    Write-Host "  > Creating backup..." -ForegroundColor White
    Start-Process -FilePath "reg.exe" -ArgumentList "export HKLM `"$backupPath`"" -Wait -NoNewWindow
    Write-Host "    [OK] Backup saved on Desktop" -ForegroundColor Green
    Read-Host "Press Enter"
}

do {
    Show-Header
    Write-Host "SELECT AN OPTION:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1]  MINIMAL - Essential tweaks"
    Write-Host "  [2]  MEDIUM  - Balanced"
    Write-Host "  [3]  EXPERT  - Maximum optimization"
    Write-Host "  [4]  STATUS  - Check configuration"
    Write-Host "  [5]  BACKUP  - Registry backup"
    Write-Host "  [0]  EXIT"
    Write-Host ""
    $choice = Read-Host "Enter number"
    switch ($choice) {
        "1" { Apply-Minimal }
        "2" { Apply-Medium }
        "3" { Apply-Expert }
        "4" { Show-Status }
        "5" { Backup-Registry }
        "0" { exit }
        default { Write-Host "Invalid option!"; Start-Sleep 1 }
    }
} while ($true)
