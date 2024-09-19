Invoke-WebRequest -Uri "https://github.com/TheElementOS/pkgs/raw/main/dist/pkgs-exe.exe" -OutFile ".\pkgs-exe.exe" -ErrorAction Stop
Invoke-WebRequest -Uri "https://github.com/TheElementOS/pkgs/raw/main/dist/pkgs.exe" -OutFile ".\pkgs.exe" -ErrorAction Stop
Invoke-WebRequest -Uri "https://github.com/TheElementOS/pkgs/raw/main/src/config.conf" -OutFile ".\config.conf" -ErrorAction Stop
Invoke-WebRequest -Uri "https://github.com/TheElementOS/pkgs/raw/main/src/config-exe.conf" -OutFile ".\config-exe.conf" -ErrorAction Stop

$folders = @(
    "C:\pkgs",
    "C:\pkgs\pkgs",
    "C:\pkgs\packages",
    "C:\pkgs\temp"
)
foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -Path $folder -ItemType Directory | Out-Null
        Write-Host "Created Folder: $folder"
    }
}

$envPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
foreach ($folder in $folders) {
    [System.Environment]::SetEnvironmentVariable("PATH", "$envPath;$folder", [System.EnvironmentVariableTarget]::User)
    Write-Host "Added to PATH: $folder"
}

$files = @(
    ".\pkgs.exe",
    ".\pkgs-exe.exe",
    ".\config.conf",
    ".\config-exe.conf"
)
foreach ($file in $files) {
    if (Test-Path $file) {
        Move-Item -Path $file -Destination "C:\pkgs\pkgs" -Force
        Write-Host "Moved $file to C:\pkgs\pkgs"
    } else {
        Write-Host "File $file does not exist"
    }
}

Set-Location ..
Remove-Item -Path ".\temp" -Recurse -Force
Write-Host "Removed temp directory"