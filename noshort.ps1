# By nxvvvv (https://github.com/nxvvvv)
# Check if the current user is an administrator
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"
if (-not $isAdmin) {
    # If not an administrator, restart the script with elevated privileges
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
}

# URL to the GitHub repository
$repositoryUrl = "https://github.com/nxvvvv/noshort"

# Display menu for the user to choose an option
Write-Host "Choose an option:"
Write-Host "1) Remove the shortcut icon"
Write-Host "2) Revert to the default shortcut icon"
Write-Host "3) Choose a custom icon"
$choice = Read-Host "Type the corresponding number (1, 2, or 3):"

# Option 1: Remove the shortcut icon
if ($choice -eq "1") {
    # Set the path and URL for the default icon
    $iconFilePath = "C:\Windows\blank.ico"
    $iconUrl = "https://raw.githubusercontent.com/nxvvvv/noshort/files/blank.ico"

    # Download the default icon
    try {
        Invoke-WebRequest -Uri $iconUrl -OutFile $iconFilePath -ErrorAction Stop
        Write-Host "Icon file downloaded successfully!"
    } catch {
        Write-Host "Error downloading icon file: $_"
        exit
    }

    # Modify registry to remove the custom icon
    # Restart Windows Explorer to apply changes
    Stop-Process -Name regedit -Force -ErrorAction SilentlyContinue
    $regKeys = @(
        "HKEY_CLASSES_ROOT\IE.AssocFile.URL",
        "HKEY_CLASSES_ROOT\InternetShortcut",
        "HKEY_CLASSES_ROOT\lnkfile"
    )
    $regKeys | ForEach-Object {
        reg add $_ /v "IsShortcut" /d "" /f
    }
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_SZ /d "$iconFilePath" /f
    taskkill /f /im explorer.exe
    Start-Sleep -Seconds 2
    Start-Process explorer.exe

    # Display success message and open the repository URL
    Write-Host "Done Successfully! Please star my repository :)"
    Start-Sleep -Seconds 2
    Start-Process $repositoryUrl
    Start-Sleep -Seconds 5
}
# Option 2: Revert to the default shortcut icon
elseif ($choice -eq "2") {
    # Set the path for the default icon
    $iconFilePath = "C:\Windows\blank.ico"

    # Modify registry to remove the custom icon
    # Delete the registry key related to custom icon
    # Remove the custom icon file
    # Restart Windows Explorer to apply changes
    Stop-Process -Name regedit -Force -ErrorAction SilentlyContinue
    $regKeys = @(
        "HKEY_CLASSES_ROOT\IE.AssocFile.URL",
        "HKEY_CLASSES_ROOT\InternetShortcut",
        "HKEY_CLASSES_ROOT\lnkfile"
    )
    $regKeys | ForEach-Object {
        reg add $_ /v "IsShortcut" /d "" /f
    }
    $registryKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
    if (Test-Path "Registry::$registryKey") {
        reg delete $registryKey /f
    }
    Remove-Item -Path $iconFilePath -Force -ErrorAction SilentlyContinue
    taskkill /f /im explorer.exe
    Start-Sleep -Seconds 2
    Start-Process explorer.exe

    # Display success message and open the repository URL
    Write-Host "Done Successfully! Please star my repository :)"
    Start-Sleep -Seconds 2
    Start-Process $repositoryUrl
    Start-Sleep -Seconds 5
}
# Option 3: Choose a custom icon
elseif ($choice -eq "3") {
    # Submenu for choosing an option related to custom icons
    Write-Host "Choose an option:"
    Write-Host "1) Select an existing icon"
    Write-Host "2) Create an icon from an image file"
    $iconChoice = Read-Host "Type the corresponding number (1 or 2):"

    # Option 1: Select an existing icon
    if ($iconChoice -eq "1") {
        # Prompt user to select an existing icon file
        $openFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "Icon Files (*.ico)|*.ico"
        $openFileDialog.Title = "Select an icon file"
        $openFileDialog.ShowDialog() | Out-Null
        $inputFile = $openFileDialog.FileName
    }
    # Option 2: Create an icon from an image file
    elseif ($iconChoice -eq "2") {
        # Prompt user to select an image file
        $openFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "Image Files (*.jpg;*.jpeg;*.png;*.gif)|*.jpg;*.jpeg;*.png;*.gif"
        $openFileDialog.Title = "Select an image file"
        $openFileDialog.ShowDialog() | Out-Null
        $inputFile = $openFileDialog.FileName

        # Create necessary directories if they don't exist
        if (-not (Test-Path "C:\noshort")) {
            New-Item -ItemType Directory -Path "C:\noshort" | Out-Null
        }
        if (-not (Test-Path "C:\noshort\ico")) {
            New-Item -ItemType Directory -Path "C:\noshort\ico" | Out-Null
        }
        if (-not (Test-Path "C:\noshort\converter")) {
            New-Item -ItemType Directory -Path "C:\noshort\converter" | Out-Null
        }

        # Define output file path and URLs for custom icon creation
        $outputFile = "C:\noshort\ico\" + [System.IO.Path]::GetFileNameWithoutExtension($inputFile) + ".ico"
        $customExePath = "C:\noshort\converter\custom.exe"
        $customExeUrl = "https://github.com/nxvvvv/noshort/raw/files/custom.exe"

        # Download custom converter tool if not present
        if (-not (Test-Path $customExePath)) {
            Write-Host "Getting converter..."
            try {
                Invoke-WebRequest -Uri $customExeUrl -OutFile $customExePath -ErrorAction Stop
                Write-Host "Success!"
            } catch {
                Write-Host "Error getting converter!?!?"
                exit
            }
        }

        # Execute custom converter tool to create the icon
        $arguments = """$inputFile"" ""$outputFile"""
        Start-Process -FilePath $customExePath -ArgumentList $arguments -Wait
    }

    # Modify registry to set the custom icon
    # Restart Windows Explorer to apply changes
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_SZ /d "$outputFile" /f
    Stop-Process -Name regedit -Force -ErrorAction SilentlyContinue
    $regKeys = @(
        "HKEY_CLASSES_ROOT\IE.AssocFile.URL",
        "HKEY_CLASSES_ROOT\InternetShortcut",
        "HKEY_CLASSES_ROOT\lnkfile"
    )
    $regKeys | ForEach-Object {
        reg add $_ /v "IsShortcut" /d "" /f
    }
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_SZ /d "$outputFile" /f
    taskkill /f /im explorer.exe
    Start-Sleep -Seconds 2
    Start-Process explorer.exe

    # Display success message and open the repository URL
    Write-Host "Done Successfully! Please star my repository :)"
    Start-Sleep -Seconds 2
    Start-Process $repositoryUrl
    Start-Sleep -Seconds 5
}
# Invalid choice
else {
    Write-Host "Invalid choice. Exiting script."
}
