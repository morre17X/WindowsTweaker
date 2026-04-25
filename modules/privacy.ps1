# privacy.ps1 - Modulo Privacy Tweak
function Invoke-PrivacyTweaks {
    param([switch]$DryRun)
    
    Write-Host ""
    Write-Host "[ MODULO PRIVACY ]" -ForegroundColor Cyan
    Write-Host ""
    
    $tweaks = @(
        @{
            Name = "Disabilita Telemetria"
            Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
            Value = "AllowTelemetry"
            Data = 0
            Type = "DWord"
        },
        @{
            Name = "Disabilita Cortana"
            Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            Value = "AllowCortana"
            Data = 0
            Type = "DWord"
        },
        @{
            Name = "Disabilita Activity History"
            Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
            Value = "EnableActivityFeed"
            Data = 0
            Type = "DWord"
        },
        @{
            Name = "Disabilita Advertising ID"
            Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
            Value = "DisabledByGroupPolicy"
            Data = 1
            Type = "DWord"
        },
        @{
            Name = "Disabilita Ricerca Cloud (Bing)"
            Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
            Value = "BingSearchEnabled"
            Data = 0
            Type = "DWord"
        },
        @{
            Name = "Disabilita Suggerimenti"
            Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
            Value = "SubscribedContent-338387Enabled"
            Data = 0
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
    
    if ($DryRun) {
        Write-Host ""
        Write-Host "[DRY RUN] Nessuna modifica applicata" -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "[COMPLETATO] Tweak privacy applicati!" -ForegroundColor Green
    }
}

Export-ModuleMember -Function Invoke-PrivacyTweaks
