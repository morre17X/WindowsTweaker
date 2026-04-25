# _loader.ps1 - Caricatore moduli automatico
$modulePath = Split-Path -Parent $MyInvocation.MyCommand.Path

$modules = @("privacy", "performance", "security")

foreach ($module in $modules) {
    $moduleFile = Join-Path $modulePath "$module.ps1"
    if (Test-Path $moduleFile) {
        . $moduleFile
        Write-Host "[LOADER] Caricato modulo: $module" -ForegroundColor DarkGray
    }
}
