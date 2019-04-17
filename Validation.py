import platform
import sys
import os

#checking os and installation status

class PreInstall:
    def find_os():
        os = platform.system()

        if os == 'Linux':
            dist = platform.dist()
            return dist[0]
        else:
            print('Only works on Linux os')
            exit(1)

    def check_packages():
        to_ins = []
        lamp_pkgs_deb = ['apache2', 'mariadb', 'php']
        lamp_pkgs_rpm = ['httpd', 'mariadb', 'php']
        if PreInstall.find_os() == 'centos' or 'fedora' or 'red hat' or 'suse':
            installer = 'yum'

            for pkg in lamp_pkgs_rpm:
                if os.system(f'rpm -qa |grep {pkg} &> /dev/null') >= 0:
                    to_ins.append(pkg)

            return installer, to_ins
        elif PreInstall.find_os() == 'debian' or 'ubuntu':
            installer = 'apt-get'

            for pkg in lamp_pkgs_deb:
                if os.system(f"dpkg -l {pkg} &> /dev/null"):
                    to_ins.append(pkg)

            return installer, to_ins

# Main Installation


ins = PreInstall.check_packages()[0]
app_list = PreInstall.check_packages()[1]

yos = input('Start installing? y/n ')

if yos == 'y':
    for app in app_list:
        os.system("sudo "f'{ins}' " install " f'{app}')
else:
    exit(1)
