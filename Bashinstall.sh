#!/usr/bin/env bash

f_distValid(){

    dist=$(hostnamectl| grep "Operating"|awk -d":" '{print $3}')
    dist=${dist,,}
    distros1="centos fedora redhat suse"
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
    elif [ $installer = yum ]; then
        for p in $lamp_pkgs_rpm; do
            rpm -qa |grep $p &> /dev/null
            if [ $? -ge 1 ]; then
                to_ins=("${to_ins[@]}" "$p")
            fi
        done
    fi

}

f_install(){

    read -p "Start Installation? [y/n] " ans
    sudo apt-get update && sudo apt-get upgrade &> /dev/null

    if [ $ans = y ]; then
        for pck in ${to_ins[@]}; do
            sudo $installer -y install $pck &> /dev/null
        done
    else
        exit
    fi

    echo "Done"
}

###  Main  ###

f_pkgVaild

    if [ -z ${to_ins[0]} ]; then
        echo "Nothing to do" ; exit
    else
        echo "need to install: ${to_ins[@]}" && f_install
    fi
