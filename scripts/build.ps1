Set-Location ..
Set-Location src

python -m venv venv
.\venv\Scripts\Activate

pip install -r requirements.txt

pyinstaller --onefile pkgs.py
pyinstaller --onefile pkgs-exe.py

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

$envPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
foreach ($folder in $folders) {
    if (-not ($envPath -contains $folder)) {
        [System.Environment]::SetEnvironmentVariable("PATH", "$envPath;$folder", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Added to PATH: $folder"
    }
}

$files = @(
    ".\dist\pkgs.exe",
    ".\dist\pkgs-exe.exe",
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
