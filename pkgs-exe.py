import os
import requests
import configparser
from colorama import Fore
import argparse
import subprocess

parser = argparse.ArgumentParser(description="Package Manager for ElementOS")
parser.add_argument('-i', type=str, help="Install package.")
args = parser.parse_args()
arg = args.i

if arg is None:
    print(Fore.RED + "Please provide the package name.")
    exit(1)

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

def download_package(repo_name, package_url):
    package_path = os.path.join(appdir, f'{arg}.exe')
    try:
        if not os.path.exists(appdir):
            os.makedirs(appdir)
        print(Fore.BLUE + f'[ {repo_name} ] Downloading from {package_url}...')
        response = requests.get(package_url)
        response.raise_for_status()
        with open(package_path, 'wb') as file:
            file.write(response.content)
        print(Fore.GREEN + f'[ {repo_name} ] Package downloaded.')

        # Uruchomienie pliku w PowerShell z pełną ścieżką
        command = f'powershell -Command "& \\"{package_path}\\""'
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        print(Fore.CYAN + f"Installation output:\n{result.stdout}")
        if result.stderr:
            print(Fore.RED + f"Installation errors:\n{result.stderr}")
            raise subprocess.CalledProcessError(returncode=1, cmd=command)

    except requests.RequestException as e:
        print(Fore.RED + f'[ {repo_name} ] Error downloading package: {str(e)}')
    except subprocess.CalledProcessError as e:
        print(Fore.RED + f'[ {repo_name} ] Error executing the package: {str(e)}')
    except Exception as e:
        print(Fore.YELLOW + f'[ {repo_name} ] An error occurred: {str(e)}')
    finally:
        # Usuwanie pliku po zakończeniu
        if os.path.exists(package_path):
            os.remove(package_path)
            print(Fore.CYAN + f'[ {repo_name} ] Package removed.')

def process_repositories(config):
    for section in config.sections():
        if 'url' in config[section]:
            repo_url = config[section]['url']
            package_url = f'{repo_url}/raw/main/pkgs/{arg}.exe'
            download_package(section, package_url)

print(Fore.CYAN + f"Searching for package {arg}...")
process_repositories(config)