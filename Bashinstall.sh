#!/usr/bin/env bash

f_distValid(){

    dist=$(sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/os-release)
    reddist=$(cat /etc/redhat-release| awk -F" " '{print $1,$2}')
    dist=${dist,,}
    distros1="centos redhat suse"
    distros2="debian ubuntu linuxmint"

    for i in $distros1; do
        if [ $dist = $i ]; then
            installer="yum"
        fi
    done

    for n in $distros2; do
        if [ $dist = $n ]; then
            installer="apt-get"
        fi
    done
    
    if [ $dist = fedora ]; then
        installer="dnf"
    elif [ $reddist = Red Hat ]; then
        installer="yum"
    fi

    if [ $? -ge 1 ]; then
        echo "os not supported" ; exit
    fi
}


f_pkgVaild(){

    lamp_pkgs_deb="apache2 mariadb-server php7.0"
    lamp_pkgs_rpm="httpd mariadb php"

    f_distValid

    if [ $installer = apt-get ]; then
        for p in $lamp_pkgs_deb; do
            dpkg -l $p &> /dev/null
            if [ $? -ge 1 ]; then
                to_ins=("${to_ins[@]}" "$p")
            fi
        done
    elif [ $installer = yum ]||[ $installer = dnf ]; then
        for p in $lamp_pkgs_rpm; do
            rpm -qa |grep $p &> /dev/null
            if [ $? -ge 1 ]; then
                to_ins=("${to_ins[@]}" "$p")
            fi
        done
    fi

}

f_install(){
    
    $installer -y install sudo &> /dev/null
    sudo apt-get update &> /dev/null && sudo apt-get upgrade &> /dev/null

        for pck in ${to_ins[@]}; do
            sudo $installer -y install $pck &> /dev/null && echo "$pck installed" || echo "$pck not installed"
        done

    echo "Done"
}

###  Main  ###

f_pkgVaild
    
    if [ -z ${to_ins[0]} ]; then
        echo "Nothing to do" ; exit
    else
        echo "need to install: ${to_ins[@]}" && f_install
    fi
