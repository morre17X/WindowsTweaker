# performance.ps1 - Modulo Performance Tweak
function Invoke-PerformanceTweaks {
    param([switch]$DryRun)
    
    Write-Host ""
    Write-Host "[ MODULO PERFORMANCE ]" -ForegroundColor Cyan
    Write-Host ""
    
    $tweaks = @(
        @{
            Name = "Disabilita Animazioni Finestre"
            Path = "HKCU:\Control Panel\Desktop"
            Value = "UserPreferencesMask"
            Data = ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
            Type = "Binary"
        },
        @{
            Name = "Disabilita Trasparenze"
            Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            Value = "EnableTransparency"
            Data = 0
            Type = "DWord"
        },
        @{
            Name = "Disabilita Animazioni Menu Start"
            Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Value = "Start_ShowClassicMode"
            Data = 1
            Type = "DWord"
        },
        @{
            Name = "Disabilita Miniature Anteprima"
            Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Value = "DisableThumbnails"
            Data = 1
            Type = "DWord"
        },
        @{
            Name = "Disabilita Effetti Dissolvenza"
            Path = "HKCU:\Control Panel\Desktop"
            Value = "MenuShowDelay"
            Data = 0
            Type = "String"
        },
        @{
            Name = "Prioritizza Processi Foreground"
            Path = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
            Value = "Win32PrioritySeparation"
            Data = 38
            Type = "DWord"
        }
    )
    
    foreach ($tweak in $tweaks) {
        Write-Host "  > $($tweak.Name)..." -ForegroundColor White
        if (-not $DryRun) {
            try {
                if (-not (Test-Path $tweak.Path)) {
                    New-Item -Path $tweak.Path -Force | Out-Null
                }
                Set-ItemProperty -Path $tweak.Path -Name $tweak.Value -Value $tweak.Data -Type $tweak.Type -Force
                Write-Host "    [OK]" -ForegroundColor Green
            } catch {
                Write-Host "    [ERRORE] $_" -ForegroundColor Red
            }
        } else {
            Write-Host "    [DRY RUN] Verrebbe applicato" -ForegroundColor Yellow
        }
    }
    
    # Power Plan
    Write-Host ""
    Write-Host "  > Imposto Piano Energetico 'Alte Prestazioni'..." -ForegroundColor White
    if (-not $DryRun) {
        try {
            powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
            Write-Host "    [OK]" -ForegroundColor Green
        } catch {
            Write-Host "    [ERRORE] Piano non disponibile" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    [DRY RUN] Verrebbe applicato" -ForegroundColor Yellow
    }
    
    # Disabilita servizi pesanti
    Write-Host ""
    Write-Host "  > Disabilito Superfetch (SysMain)..." -ForegroundColor White
    if (-not $DryRun) {
        try {
            Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "    [OK]" -ForegroundColor Green
        } catch {
            Write-Host "    [ATTENZIONE] Servizio non trovato" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    [DRY RUN] Verrebbe disabilitato" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "  > Disabilito Windows Search..." -ForegroundColor White
    if (-not $DryRun) {
        try {
            Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "    [OK]" -ForegroundColor Green
        } catch {
            Write-Host "    [ATTENZIONE] Servizio non trovato" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    [DRY RUN] Verrebbe disabilitato" -ForegroundColor Yellow
    }
    
    if ($DryRun) {
        Write-Host ""
        Write-Host "[DRY RUN] Nessuna modifica applicata" -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "[COMPLETATO] Tweak performance applicati!" -ForegroundColor Green
        Write-Host "[INFO] Alcune modifiche richiedono il riavvio" -ForegroundColor Cyan
    }
}

Export-ModuleMember -Function Invoke-PerformanceTweaks
