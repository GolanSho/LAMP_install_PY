import platform
import sys
import os

# checking os and installation status


def find_os():
    _os = platform.system()

    if _os == 'Linux':
        _linux = 1
        return _linux
    else:
        print('Only works on Linux os')
        exit(1)


def check_packages():
    to_ins = []
    dist = platform.dist()[0].lower()
    lamp_pkgs_deb = ['apache2', 'mariadb', 'php']
    lamp_pkgs_rpm = ['httpd', 'mariadb', 'php']

    if find_os() == 1:
        if dist in ['centos', 'fedora', 'red hat', 'suse']:
            installer = 'yum'

            for pkg in lamp_pkgs_rpm:
                if os.system(f'rpm -qa |grep {pkg} &> /dev/null') >= 0:
                    to_ins.append(pkg)

        if dist in ['debian', 'ubuntu', 'linuxmint']:
            installer = 'apt-get'

            for pkg in lamp_pkgs_deb:
                if os.system(f"dpkg -l {pkg} &> /dev/null") >= 0:
                    to_ins.append(pkg)

        return installer, to_ins
    else:
        print('os unsupported')
        exit(1)

# Main Installation


insinfo = check_packages()
ins =insinfo[0]
app_list = insinfo[1]

yos = input('Start installing? y/n ')

if yos == 'y':
    for app in app_list:
        os.system("sudo "f'{ins}' " -y install " f'{app}' "&> /dev/null")
        print(f'{app} Installed')
else:
    exit(1)
