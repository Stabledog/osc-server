#!/usr/bin/env pwsh
# Open Stage Control Launch Script
# This script launches the OSC server with the configured options

param(
    [switch]$NoLayout
)

# Get the script directory to use relative paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define paths
$OSCExecutable = Join-Path $ScriptDir "open-stage-control_win32-x64\open-stage-control.exe"
$ConfigFile = Join-Path $ScriptDir "my-osc.config"
$LayoutFile = Join-Path $ScriptDir "layouts\transport-panel.json"

# Check if files exist
if (-not (Test-Path $OSCExecutable)) {
    Write-Error "OSC executable not found at: $OSCExecutable"
    exit 1
}

if (-not (Test-Path $ConfigFile)) {
    Write-Error "Config file not found at: $ConfigFile"
    exit 1
}

if (-not (Test-Path $LayoutFile)) {
    Write-Error "Layout file not found at: $LayoutFile"
    exit 1
}

# Launch Open Stage Control
Write-Host "Launching Open Stage Control..." -ForegroundColor Green
Write-Host "Config: $ConfigFile" -ForegroundColor Cyan
if (-not $NoLayout) {
    Write-Host "Layout: $LayoutFile" -ForegroundColor Cyan
} else {
    Write-Host "No layout file (clean start)" -ForegroundColor Yellow
}

# Change to the OSC executable directory before launching
$OSCDir = Split-Path -Parent $OSCExecutable
Push-Location $OSCDir

try {
    # Use absolute paths for config and layout files
    $AbsConfigFile = Resolve-Path $ConfigFile
    
    Write-Host "Working directory: $OSCDir" -ForegroundColor Yellow
    Write-Host "Absolute config path: $AbsConfigFile" -ForegroundColor Yellow
    
    if (-not $NoLayout) {
        $AbsLayoutFile = Resolve-Path $LayoutFile
        Write-Host "Absolute layout path: $AbsLayoutFile" -ForegroundColor Yellow
        & ".\open-stage-control.exe" --config-file $AbsConfigFile --load $AbsLayoutFile
    } else {
        & ".\open-stage-control.exe" --config-file $AbsConfigFile
    }
} catch {
    Write-Error "Failed to launch Open Stage Control: $_"
    exit 1
} finally {
    # Return to original directory
    Pop-Location
}
