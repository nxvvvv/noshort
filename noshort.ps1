# By nxvvvv (https://github.com/nxvvvv)
# Check if the script is running with administrative privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"
if (-not $isAdmin) {
    # If not running as admin, relaunch the script with elevated privileges
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

# Define the repository URL
$repositoryUrl = "https://github.com/nxvvvv/noshort"

# Prompt the user for their choice
Write-Host "Choose an option:"
Write-Host "1) Remove the shortcut icon"
Write-Host "2) Revert to the default shortcut icon"
$choice = Read-Host "Type the corresponding number (1 or 2):"

# Check the user's choice
if ($choice -eq "1") {
    # Remove the shortcut icon

    # Define the icon file path and URLs
    $iconFilePath = "C:\Windows\blank.ico"
    $iconUrl = "https://raw.githubusercontent.com/nxvvvv/noshort/main/blank.ico"

    # Download the icon file with error handling
    try {
        $downloadedIcon = Invoke-WebRequest -Uri $iconUrl -OutFile $iconFilePath -ErrorAction Stop
        Write-Host "Icon file downloaded successfully!"
    } catch {
        Write-Host "Error downloading icon file: $_"
        exit
    }

    # Close regedit.exe if it's running
    Stop-Process -Name regedit -Force -ErrorAction SilentlyContinue

    # Set registry entries individually
    reg add "HKEY_CLASSES_ROOT\IE.AssocFile.URL" /v "IsShortcut" /d "" /f
    reg add "HKEY_CLASSES_ROOT\InternetShortcut" /v "IsShortcut" /d "" /f
    reg add "HKEY_CLASSES_ROOT\lnkfile" /v "IsShortcut" /d "" /f

    # Set registry entry for Shell Icons
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_SZ /d "$iconFilePath" /f

    # Restart Explorer.exe without opening a new window
    taskkill /f /im explorer.exe
    Start-Sleep -Seconds 2
    Start-Process explorer.exe

    # Display "Done Successfully!" and open repo
    Write-Host "Done Successfully! Please star my repository :)"
    Start-Sleep -Seconds 2
    Start-Process $repositoryUrl

    # Wait for 5 seconds before closing
    Start-Sleep -Seconds 5
}
elseif ($choice -eq "2") {
    # Revert to the default shortcut icon

    # Define the icon file path
    $iconFilePath = "C:\Windows\blank.ico"

    # Close regedit.exe if it's running
    Stop-Process -Name regedit -Force -ErrorAction SilentlyContinue

    # Set registry entries individually to default shortcut icons
    reg add "HKEY_CLASSES_ROOT\IE.AssocFile.URL" /v "IsShortcut" /d "" /f
    reg add "HKEY_CLASSES_ROOT\InternetShortcut" /v "IsShortcut" /d "" /f
    reg add "HKEY_CLASSES_ROOT\lnkfile" /v "IsShortcut" /d "" /f

    # Check if the registry key exists before attempting to delete
    $registryKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
    if (Test-Path "Registry::$registryKey") {
        # Delete the Shell Icons key
        reg delete $registryKey /f
    }

    # Delete the icon file
    Remove-Item -Path $iconFilePath -Force -ErrorAction SilentlyContinue

    # Restart Explorer.exe without opening a new window
    taskkill /f /im explorer.exe
    Start-Sleep -Seconds 2
    Start-Process explorer.exe

    # Display "Done Successfully!" and open repo
    Write-Host "Done Successfully! Please star my repository :)"
    Start-Sleep -Seconds 2
    Start-Process $repositoryUrl

    # Wait for 5 seconds before closing
    Start-Sleep -Seconds 5
}
else {
    Write-Host "Invalid choice. Exiting script."
}
