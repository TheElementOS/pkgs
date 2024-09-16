Invoke-WebRequest -Uri "https://github.com/elementos/eourcore/tags/0.1/pkgs.exe" -OutFile ".\pkgs.exe"
Invoke-WebRequest -Uri "https://github.com/elementos/eourcore/tags/0.1/config.conf" -OutFile ".\config.conf"
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
Move-Item -Path ".\dist\pkgs-exe.exe" -Destination "C:\pkgs\pkgs"
Move-Item -Path ".\config.conf" -Destination "C:\pkgs\pkgs"
Move-Item -Path ".\config-exe.conf" -Destination "C:\pkgs\pkgs"