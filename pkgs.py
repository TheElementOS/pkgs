import os
import requests
import configparser
from colorama import Fore
import argparse
import zipfile
import time

parser = argparse.ArgumentParser(description="Package Manager do ElementOS")
parser.add_argument('-i', type=str, help="Zainstaluj paczkę.")
args = parser.parse_args()
arg = args.i

if arg is None:
    print(Fore.RED + "Podaj nazwę programu.")
    exit(1)

zip_path = f'C:\\pkgs\\packages\\{arg}.zip'
extract_to = 'C:\\pkgs\\packages'
output_dir = 'C:\\pkgs\\packages'

config = configparser.ConfigParser()
config.read('config.conf')

print(Fore.CYAN + f"Szukanie paczki {arg}...")

def download_package(repo_name, package_url):
    try:
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        print(Fore.BLUE + f'[ {repo_name} ] Pobieranie z {package_url}...')
        response = requests.get(package_url)
        if response.status_code == 200:
            package_path = os.path.join(output_dir, f'{repo_name}.zip')
            with open(package_path, 'wb') as file:
                file.write(response.content)
            print(Fore.GREEN + f'[ {repo_name} ] Pobrano paczke.')
            with zipfile.ZipFile(package_path, 'r') as zip_ref:
                zip_ref.extractall(extract_to)
            print(Fore.CYAN + f"Zainstalowano!")
            os.remove(package_path)
        else:
            print(Fore.RED + f'[ {repo_name} ] Błąd pobierania paczki. Kod odpowiedzi: {response.status_code}')
    except Exception as e:
        print(Fore.YELLOW + f'[ {repo_name} ] Wystąpił błąd podczas pobierania paczki: {str(e)}')

def process_repositories(config):
    for section in config.sections():
        if 'url' in config[section]:
            repo_url = config[section]['url']
            package_url = f'{repo_url}/raw/main/pkgs/{arg}.zip'
            download_package(section, package_url)

process_repositories(config)