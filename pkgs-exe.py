import os
import requests
import configparser
from colorama import Fore
import argparse
import zipfile
import subprocess

os.chdir('C:\\pkgs\\packages')

parser = argparse.ArgumentParser(description="Package Manager for ElementOS")
parser.add_argument('-i', type=str, help="Install package.")
args = parser.parse_args()
arg = args.i

if arg is None:
    print(Fore.RED + "Please provide the package name.")
    exit(1)

print(Fore.BLUE + f"Trying to download {arg}")

if arg == "choco":
    print(Fore.CYAN + "Installing choco...")
    command = [
        "powershell", 
        "-Command", 
        "Set-ExecutionPolicy Bypass -Scope Process -Force; "
        "[System.Net.ServicePointManager]::SecurityProtocol = "
        "[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; "
        "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    ]
    result = subprocess.run(command, capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)
    exit(0)

appdir = 'C:\\pkgs\\temp'

config = configparser.ConfigParser()
config.read('config-exe.conf')

print(Fore.CYAN + f"Searching for package {arg}...")

def download_package(repo_name, package_url):
    try:
        if not os.path.exists(appdir):
            os.makedirs(appdir)
        print(Fore.BLUE + f'[ {repo_name} ] Downloading from {package_url}...')
        response = requests.get(package_url)
        if response.status_code == 200:
            package_path = os.path.join(appdir, f'{repo_name}.exe')
            with open(package_path, 'wb') as file:
                file.write(response.content)
            print(Fore.GREEN + f'[ {repo_name} ] Package downloaded.')
            subprocess.run(f'powershell ./{arg}.exe', capture_output=True, text=True)
            print(Fore.CYAN + f"Installed!")
            os.remove(package_path)
        else:
            print(Fore.RED + f'[ {repo_name} ] Error downloading package. Response code: {response.status_code}')
    except Exception as e:
        print(Fore.YELLOW + f'[ {repo_name} ] An error occurred while downloading the package: {str(e)}')

def process_repositories(config):
    for section in config.sections():
        if 'url' in config[section]:
            repo_url = config[section]['url']
            package_url = f'{repo_url}/raw/main/pkgs/{arg}.exe'
            download_package(section, package_url)

process_repositories(config)