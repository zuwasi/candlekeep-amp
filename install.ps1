# CandleKeep + Amp Installation Script (Windows)
# Run: powershell -ExecutionPolicy Bypass -File install.ps1

Write-Host "=== CandleKeep + Amp Setup ===" -ForegroundColor Cyan
Write-Host ""

# 1. Install ck.exe
$binDir = "$env:USERPROFILE\.local\bin"
if (!(Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir -Force | Out-Null
}
Copy-Item "$PSScriptRoot\bin\ck.exe" "$binDir\ck.exe" -Force
Write-Host "[1/3] Installed ck.exe to $binDir" -ForegroundColor Green

# Add to PATH if not already there
$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
if ($userPath -notlike "*\.local\bin*") {
    [Environment]::SetEnvironmentVariable('PATH', "$userPath;$binDir", 'User')
    Write-Host "      Added $binDir to PATH (restart terminal to take effect)" -ForegroundColor Yellow
} else {
    Write-Host "      Already in PATH" -ForegroundColor Gray
}

# 2. Install Amp skill
$skillDir = "$env:USERPROFILE\.agents\skills\candlekeep"
if (!(Test-Path $skillDir)) {
    New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
}
Copy-Item "$PSScriptRoot\skills\candlekeep\SKILL.md" "$skillDir\SKILL.md" -Force
Copy-Item "$PSScriptRoot\skills\candlekeep\README.md" "$skillDir\README.md" -Force
Write-Host "[2/3] Installed CandleKeep skill to $skillDir" -ForegroundColor Green

# 3. Authenticate
Write-Host "[3/3] Authenticating with CandleKeep Cloud..." -ForegroundColor Cyan
Write-Host ""
Write-Host "      Opening browser for login..." -ForegroundColor Yellow
Write-Host "      If browser doesn't open, visit: https://getcandlekeep.com" -ForegroundColor Yellow
Write-Host ""
& "$binDir\ck.exe" auth login

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open a NEW terminal (so PATH takes effect)"
Write-Host "  2. Upload a document:  ck items add your-document.pdf"
Write-Host "  3. In Amp, ask:        'What does my library say about...'"
Write-Host ""
Write-Host "See examples\ folder for a real-world MISRA C cross-standard analysis." -ForegroundColor Gray
