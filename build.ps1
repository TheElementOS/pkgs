python -m venv venv
.\venv\Scripts\Activate
pip install -r requirements.txt
pyinstaller --onefile pkgs.py
$folders = @(
    "C:\pkgs",
    "C:\pkgs\pkgs",
    "C:\pkgs\packages"
)
foreach ($folder in $folders) {
    New-Item -Path $folder -ItemType Directory
    Write-Host "Created Folder: $folder"
}
$envPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
foreach ($folder in $folders) {
        [System.Environment]::SetEnvironmentVariable("PATH", "$envPath;$folder", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Added to PATH: $folder"
}
Move-Item -Path ".\dist\pkgs.exe" -Destination "C:\pkgs\pkgs"
Move-Item -Path ".\config.conf" -Destination "C:\pkgs\pkgs"