# security.ps1 - Modulo Security Tweak
function Invoke-SecurityTweaks {
    param([switch]$DryRun)
    
    Write-Host ""
    Write-Host "[ MODULO SICUREZZA ]" -ForegroundColor Cyan
    Write-Host ""
    
    $tweaks = @(
        @{
            Name = "Abilita UAC (Massimo)"
            Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "EnableLUA"
            Data = 1
            Type = "DWord"
        },
        @{
            Name = "UAC - Prompt sempre visibile"
            Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            Value = "ConsentPromptBehaviorAdmin"
            Data = 2
            Type = "DWord"
        },
        @{
            Name = "Blocca Script da Internet"
            Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations"
            Value = "BlockFileDownload"
            Data = 1
            Type = "DWord"
        },
        @{
            Name = "Disabilita PowerShell Remoto"
            Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell"
            Value = "EnableRemoteScripts"
            Data = 0
            Type = "DWord"
        },
        @{
            Name = "Disabilita AutoPlay (USB/CD)"
            Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            Value = "NoDriveTypeAutoRun"
            Data = 255
            Type = "DWord"
        },
        @{
            Name = "Blocca Installazioni Non Admin"
            Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx"
            Value = "BlockNonAdminUserInstall"
            Data = 1
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
    
    # Disabilita SMB1 (protocollo vulnerabile)
    Write-Host ""
    Write-Host "  > Disabilito SMB1 Protocol (sicurezza)..." -ForegroundColor White
    if (-not $DryRun) {
        try {
            Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart -ErrorAction SilentlyContinue
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
            Write-Host "    [OK]" -ForegroundColor Green
        } catch {
            Write-Host "    [ATTENZIONE] SMB1 potrebbe essere già disabilitato" -ForegroundColor Yellow
        }
    } else {
        Write-Host "    [DRY RUN] Verrebbe disabilitato" -ForegroundColor Yellow
    }
    
    # Rafforza Windows Defender
    Write-Host ""
    Write-Host "  > Rafforzamento Windows Defender..." -ForegroundColor White
    
    $defenderTweaks = @(
        @{Name="Cloud Protection"; Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet"; Value="SpynetReporting"; Data=2},
        @{Name="Real-time Monitoring"; Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; Value="DisableRealtimeMonitoring"; Data=0},
        @{Name="Signature Updates"; Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates"; Value="ForceUpdateFromMU"; Data=1}
    )
    
    foreach ($tweak in $defenderTweaks) {
        Write-Host "    - $($tweak.Name)..." -ForegroundColor Gray
        if (-not $DryRun) {
            try {
                $path = $tweak.Path
                if (-not (Test-Path $path)) {
                    New-Item -Path $path -Force | Out-Null
                }
                Set-ItemProperty -Path $path -Name $tweak.Value -Value $tweak.Data -Type "DWord" -Force -ErrorAction SilentlyContinue
            } catch {
                # Ignora errori di Defender
            }
        }
    }
    Write-Host "    [OK]" -ForegroundColor Green
    
    if ($DryRun) {
        Write-Host ""
        Write-Host "[DRY RUN] Nessuna modifica applicata" -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "[COMPLETATO] Tweak sicurezza applicati!" -ForegroundColor Green
        Write-Host "[INFO] Riavvia il PC per completare" -ForegroundColor Cyan
    }
}

Export-ModuleMember -Function Invoke-SecurityTweaks
