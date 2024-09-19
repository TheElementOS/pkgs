Set-Location ..
mkdir temp
Set-Location temp

Invoke-WebRequest -Uri "https://github.com/TheElementOS/pkgs/raw/refs/heads/main/dist/pkgs-exe.exe" -OutFile ".\pkgs-exe.exe"
Invoke-WebRequest -Uri "https://github.com/TheElementOS/pkgs/raw/refs/heads/main/dist/pkgs.exe" -OutFile ".\pkgs.exe"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TheElementOS/pkgs/refs/heads/main/config.conf" -OutFile ".\config.conf"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TheElementOS/pkgs/refs/heads/main/config-exe.conf" -OutFile ".\config-exe.conf"

$folders = @(
    "C:\pkgs",
    "C:\pkgs\pkgs",
    "C:\pkgs\packages",
    "C:\pkgs\temp"
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
Move-Item -Path ".\pkgs.exe" -Destination "C:\pkgs\pkgs"
Move-Item -Path ".\pkgs-exe.exe" -Destination "C:\pkgs\pkgs"
Move-Item -Path ".\config.conf" -Destination "C:\pkgs\pkgs"
Move-Item -Path ".\config-exe.conf" -Destination "C:\pkgs\pkgs"
Remove-Item -Path "." -Force