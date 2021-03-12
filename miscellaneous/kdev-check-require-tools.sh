#!/bin/env bash
### BEGIN INIT INFO
# Short-Description: Checks whether the tools needed to compile the kernel are
#                    installed.
#
### END INIT INFO
#
# Author:            Rafael Mendes <rafaelmendes.dev@gmail.com>
#

#######################################
# Checks whether the tools needed to compile the kernel.
# Globals:
#   None
# Outputs:
#  Installation status of the package.
#######################################
function check_pkg() {
  local pkg_list
  local pkg_min_version
  local pkg_name
  local pkg_version
  local pkg_not_installed

  pkg_list=("gcc" "make" "binutils" "flex" "bison" "util-linux" "kmod" \
            "e2fsprogs" "jfsutils" "reiserfsprogs" "xfsprogs" "squashfs-tools" \
            "btrfs-progs" "pcmciautils" "ppp" "libnfs-utils" "procps" "udev" \
            "grub-common" "iptables" "openssl" "bc" "sphinx-common")
  pkg_min_version=("4.9" "3.81" "2.23" "2.5.35" "2.0" "2.10o" "13" "1.41.4" \
                   "1.1.3" "3.6.3" "2.6.0" "4.0" "0.18" "004" "2.4.0" "1.0.5" \
                   "3.2.0" "081" "0.93" "1.4.2" "1.0.0" "1.06.95" "1.3")

  echo -e "\nChecking the necessary tools are installed."

  for ((pkg=0,ver=0;pkg<${#pkg_list[@]};pkg++,ver++)); do
    echo -e "\nChecking \"${pkg_list[${pkg}]}\"..."
    sleep 0.5

    dpkg -s ${pkg_list[${pkg}]} > /dev/null 2>&1

    if (( $? == 0 )); then
      pkg_name=$(dpkg -s ${pkg_list[${pkg}]} 2> /dev/null \
        | egrep -io "Package: .*")
      pkg_version=$(dpkg -s ${pkg_list[${pkg}]} 2> /dev/null \
        | egrep -io "Version: .*")
      echo -e "[ \e[1;32mYes\e[0m ]  ${pkg_name}"
      echo "         ${pkg_version} (>= ${pkg_min_version[${ver}]})"
    else
      echo -e "[ \e[1;31mNo\e[0m ]   \"${pkg_list[${pkg}]}\" not installed."
      pkg_not_installed+=(${pkg_list[${pkg}]})
    fi
  done

  if (( ${#pkg_not_installed[@]} != 0 )); then
    echo -e "\nRun the following command to install packages that are not \
installed:"
    echo -e "\n    \"sudo apt install ${pkg_not_installed[@]}\""
  fi

  echo -e "\nTools to be obtained from other sources:\n"
  echo -e "    \e[1;31mquota-tools\e[0m (>= 3.09)"
  echo -e "    https://sourceforge.net/projects/linuxquota/files/quota-tools/\n"
  echo -e "    \e[1;31moprofile\e[0m (>= 0.9)"
  echo -e "    https://oprofile.sourceforge.io/download/\n"
  echo -e "    \e[1;31mmcelog\e[0m (>= 0.6)"
  echo -e "    https://mcelog.org/installation.html\n"
}

check_pkg
unset pkg_list pkg_min_version pkg pkg_name pkg_version pkg_not_installed
