#!/bin/env bash
### BEGIN INIT INFO
# Short-Description: Standardize the names of VMs for study and organization
#                    purposes.
#
# Description:       VM name:
#
#                     .---------------------------------- VM_TYPE
#                     |     .---------------------------- VM_DISTRO
#                     |     |    .----------------------- VM_DISTRO_VERSION
#                     |     |    |  .-------------------- VM_MAIN_SERVICE
#                     |     |    |  |    .--------------- VM_ARCH
#                     |     |    |  |    |       .------- VM_ID
#                     |     |    |  |    |       |
#                    .--..-----..-..--..----..--------.
#                    SRV_DEBIAN_10_FTP_AMD64_VMID_A54D
#
#                    - Type: server or station
#                    - OS: operating system (Linux or Windows)
#                    - Distro: GNU/Linux distribution used (if OS is Linux)
#                    - Windows version: Windows version (if OS is Windows)
#                    - Distro version: version of the distro used
#                    - Main service: the main service used on the VM
#                      (used for VM type server)
#                    - Arch: VM architecture
#                    - ID: unique identification for each VM
#
#                    HD name:
#
#                      .-------------------------- HD_TYPE
#                      |       .------------------ VM_ID
#                      |       |       .---------- HD_SIZE
#                      |       |       |     .---- HD_ID
#                      |       |       |     |
#                    .----..--------..----..---.
#                    FIXED_VMID_CFC2_100GB_CBC9
#
#                    - HD_TYPE: HD type (fixed or dynamic)
#                    - VM_ID: identification of the VM that this HD is
#                      associated with
#                    - HD_SIZE: HD size in GB
#                    - HD_ID: unique identification for each HD
### END INIT INFO
#
# Author:            Rafael Mendes <rafaelmendes.dev@gmail.com>
#

VM_TYPE=""
VM_ID=""
VM_OS=""
VM_DISTRO=""
WIN_VERSION=""
VM_DISTRO_VERSION=""
VM_MAIN_SERVICE=""
VM_ARCH=""
VM_NAME=""
HD_TYPE=""
HD_SIZE=""
HD_ID=""
FILE_PATH="${HOME}/.vms.txt"

#######################################
# Checks whether the entry is a number.
# Globals:
#   None
# Outputs:
#   An invalid option alert.
#######################################
function check_is_number() {
  local is_number='^[0-9]+([.][0-9]+)?$'

  if ! [[ $1 =~ ${is_number} ]]; then
    echo "Invalid option!"
    exit 1
  fi
}

#######################################
# Make VM type.
# Globals:
#   VM_TYPE
# Outputs:
#   A list of VM types to choose from.
#######################################
function vm_type() {
  echo -e "\n\t\t****** VM type ******\n"

  echo -e "[1] SRV (server)\n[2] STT (station)\n"
  read -p "Enter VM type [default STT]: " VM_TYPE
  if [[ -z ${VM_TYPE} ]]; then
    :
  else
    check_is_number ${VM_TYPE}
  fi

  VM_TYPE=$(echo ${VM_TYPE} | tr -d ' ')

  case ${VM_TYPE} in
    1)
      VM_TYPE="SRV"
      ;;
    2)
      VM_TYPE="STT"
      ;;
  esac

  if [[ -z ${VM_TYPE} ]]; then
    VM_TYPE="STT"
  elif [[ -n ${VM_TYPE} ]]; then
    VM_TYPE=${VM_TYPE}
  fi
}

#######################################
# Make VM ID.
# Globals:
#   VM_ID
# Outputs:
#   None
#######################################
function vm_id() {
  VM_ID=$(openssl rand -hex 2)
  VM_ID=$(echo ${VM_ID} | tr [:lower:] [:upper:])
}

#######################################
# Make OS.
# Globals:
#   VM_OS
# Outputs:
#   OS options: "Linux" or "Windows".
#######################################
function os() {
  echo -e "\n\t\t****** OS ******\n"

  echo -e "[1] Linux\n[2] Windows\n"
  read -p "Enter OS [default Linux]: " VM_OS
  if [[ -z ${VM_OS} ]]; then
    :
  else
    check_is_number ${VM_OS}
  fi

  VM_OS=$(echo ${VM_OS} | tr -d ' ')

  case ${VM_OS} in
    1)
      VM_OS="Linux"
      ;;
    2)
      VM_OS="Windows"
      ;;
  esac

  if [[ -z ${VM_OS} ]]; then
    VM_OS="Linux"
  elif [[ -n ${VM_OS} ]]; then
    VM_OS=${VM_OS}
  fi
}

#######################################
# Make Linux distro.
# Globals:
#   VM_DISTRO
# Outputs:
#   Linux distros to choose from.
#######################################
function linux_distro() {
  local distro
  local num_of_distro

  # Total distro that are in the JSON file.
  num_of_distro=$(jq -r ".OS[0].Linux[].Name" named-vm.json | wc -l)

  echo -e "\n\t\t****** GNU/Linux Distros ******\n"

  # Displays the distros to choose from.
  for line_one in $(seq 0 3); do
    distro=$(jq -r ".OS[0].Linux[${line_one}].Name" named-vm.json)
    echo -ne "[$(expr ${line_one} + 1)] ${distro}\t"
    line_one+=1
  done
  echo ""
  for line_two in $(seq 4 7); do
    distro=$(jq -r ".OS[0].Linux[${line_two}].Name" named-vm.json)
    echo -ne "[$(expr ${line_two} + 1)] ${distro}\t"
    line_two+=1
  done
  echo ""
  for line_three in $(seq 8 11); do
    distro=$(jq -r ".OS[0].Linux[${line_three}].Name" named-vm.json)
    echo -ne "[$(expr ${line_three} + 1)] ${distro}\t"
    line_three+=1
  done
  echo ""
  for line_four in $(seq 12 15); do
    distro=$(jq -r ".OS[0].Linux[${line_four}].Name" named-vm.json)
    echo -ne "[$(expr ${line_four} + 1)] ${distro}\t"
    line_four+=1
  done

  echo -e "\n"; read -p "Enter distro [default none]: " VM_DISTRO
  if [[ -z ${VM_DISTRO} ]]; then
    :
  else
    check_is_number ${VM_DISTRO}
  fi

  VM_DISTRO=$(echo ${VM_DISTRO} | tr -d ' ')

  for u in $(seq 0 $(expr ${num_of_distro} - 1)); do
    case ${VM_DISTRO} in
      $(expr ${u} + 1))
        VM_DISTRO=$(jq -r ".OS[0].Linux[${u}].Name" named-vm.json)
        break
        ;;
    esac
    u+=1
  done

  if [[ -z ${VM_DISTRO} ]]; then
    VM_DISTRO=""
  elif [[ -z ${VM_DISTRO} ]]; then
    VM_DISTRO=${VM_DISTRO}
  fi
}

#######################################
# Make Linux distro version.
# Globals:
#   VM_DISTRO
#   VM_DISTRO_VERSION
# Outputs:
#   The list of versions of the distribution chosen in the previous
#   step and option to choose the version.
#######################################
function distro_version() {
  local num_of_distro
  local num_of_version
  local distro_name
  local distro_index

  # Total distro that are in the JSON file.
  num_of_distro=$(jq -r ".OS[0].Linux[].Name" named-vm.json | wc -l)

  echo -e "\n\t\t***** Distro version *****\n"

  for k in $(seq 0 $(expr ${num_of_distro} - 1)); do
    num_of_version=$(jq -r ".OS[0].Linux[${k}].Version[]" named-vm.json | wc -l)
    distro_name=$(jq -r ".OS[0].Linux[${k}].Name" named-vm.json)
    distro_index=${k}

    case ${VM_DISTRO} in
      ${distro_name})
        echo -e "[${distro_name} versions]\n"
        for i in $(seq 0 $(expr ${num_of_version} - 1)); do
          echo "[$(expr ${i} + 1)] $(jq -r ".OS[0].Linux[${k}].Version[${i}]" \
          named-vm.json)"
          i+=1
        done
        break
        ;;
    esac
    k+=1
  done

  echo ""; read -p "Enter distro version [default last release]: " \
  VM_DISTRO_VERSION
  if [[ -z ${VM_DISTRO_VERSION} ]]; then
    :
  else
    check_is_number ${VM_DISTRO_VERSION}
  fi

  # Delete the characters from the version name (which are given as input other
  # than those shown)
  VM_DISTRO_VERSION=$(echo ${VM_DISTRO_VERSION} \
    | tr -d ' ' \
    | tr -d '.' \
    | tr -d '-')

  for f in $(seq 0 $(expr ${num_of_version} - 1)); do
    case ${VM_DISTRO_VERSION} in
      $(expr ${f} + 1))
        VM_DISTRO_VERSION=$(jq -r ".OS[0].Linux[${distro_index}].Version[${f}]" \
        named-vm.json)
        break
        ;;
    esac
    f+=1
  done

  if [[ -z ${VM_DISTRO_VERSION} ]]; then
    VM_DISTRO_VERSION=$(jq -r ".OS[0].Linux[${distro_index}].Version[-1]" \
    named-vm.json)
  elif [[ -n ${VM_DISTRO_VERSION} ]]; then
    VM_DISTRO_VERSION=${VM_DISTRO_VERSION}
  fi

  # Delete the characters from the version name (which are displayed for
  # choice).
  VM_DISTRO_VERSION=$(echo ${VM_DISTRO_VERSION} \
    | tr -d ' ' \
    | tr -d '.' \
    | tr -d '-')
}

#######################################
# Make Windows version.
# Globals:
#   VM_TYPE
#   WIN_VERSION
# Outputs:
#   List of Windows versions to choose from.
#######################################
function win_version() {
  local num_of_version_stt
  local num_of_version_srv
  local srv_version
  local stt_version

  num_of_version_stt=$(jq -r ".OS[1].Windows[0].Version[]" named-vm.json \
    | wc -l)
  num_of_version_srv=$(jq -r ".OS[1].Windows[1].Version[]" named-vm.json \
    | wc -l)

  # Display of version names for server type.
  if [[ ${VM_TYPE} == "SRV" ]]; then
    echo -e "\n\t\t****** Windows Server versions ******\n"

    for j in $(seq 0 $(expr ${num_of_version_srv} - 1)); do
      srv_version=$(jq -r ".OS[1].Windows[1].Version[${j}]" named-vm.json)
      echo -e "[$(expr ${j} + 1)] ${srv_version}"
      j+=1
    done

    echo -e ""
    read -p "Enter Windows Server version [default last release]: " WIN_VERSION
    if [[ -z ${WIN_VERSION} ]]; then
      :
    else
      check_is_number ${WIN_VERSION}
    fi

    # Delete the characters from the version name (which are given as input
    # different from the ones displayed)
    WIN_VERSION=$(echo ${WIN_VERSION} | tr -d ' ' | tr -d '.' | tr -d '-')

    for l in $(seq 0 $(expr ${num_of_version_srv} - 1)); do
      case ${WIN_VERSION} in
        $(expr ${l} + 1))
          WIN_VERSION=$(jq -r ".OS[1].Windows[1].Version[${l}]" named-vm.json)
          break
          ;;
      esac
      l+=1
    done

    if [[ -z ${WIN_VERSION} ]]; then
      WIN_VERSION=$(jq -r ".OS[1].Windows[1].Version[-1]" named-vm.json)
    elif [[ -z ${WIN_VERSION} ]]; then
      WIN_VERSION=${WIN_VERSION}
    fi

    # Delete the characters from the version name (which are displayed for
    # choice).
    WIN_VERSION=$(echo ${WIN_VERSION} | tr -d ' ' | tr -d '.' | tr -d '-')
  # Displaying version names for station type.
  elif [[ ${VM_TYPE} == "STT" ]]; then
    echo -e "\n\t\t****** Windows versions ******\n"

    for m in $(seq 0 $(expr ${num_of_version_stt} - 1)); do
      stt_version=$(jq -r ".OS[1].Windows[0].Version[${m}]" named-vm.json)
      echo -e "[$(expr ${m} + 1)] ${stt_version}"
      m+=1
    done

    echo -e ""
    read -p "Enter Windows version [default last release]: " WIN_VERSION
    if [[ -z ${WIN_VERSION} ]]; then
      :
    else
      check_is_number ${WIN_VERSION}
    fi

    # Delete the characters from the version name (which are given as input
    # different from the ones displayed)
    WIN_VERSION=$(echo ${WIN_VERSION} | tr -d ' ' | tr -d '.' | tr -d '-')

    for p in $(seq 0 $(expr ${num_of_version_stt} - 1)); do
      case ${WIN_VERSION} in
        $(expr ${p} + 1))
          WIN_VERSION=$(jq -r ".OS[1].Windows[0].Version[${p}]" named-vm.json)
          break
          ;;
      esac
      p+=1
    done

    if [[ -z ${WIN_VERSION} ]]; then
      WIN_VERSION=$(jq -r ".OS[1].Windows[0].Version[-1]" named-vm.json)
    elif [[ -n ${WIN_VERSION} ]]; then
      WIN_VERSION=${WIN_VERSION}
    fi

    # Delete the characters from the version name (which are displayed for
    # choice).
    WIN_VERSION=$(echo ${WIN_VERSION} | tr -d ' ' | tr -d '.' | tr -d '-')
  fi
}

#######################################
# Make main service.
# Globals:
#   VM_TYPE
#   VM_MAIN_SERVICE
# Outputs:
#   Choose the "main service" for the VM.
#######################################
function main_service()  {
  if [[ ${VM_TYPE} == "SRV" ]]; then
    echo -e "\n\t\t***** Main service *****\n"

    read -p "Enter main service (FTP, DNS, DB) [default none]: " VM_MAIN_SERVICE
    VM_MAIN_SERVICE=$(echo ${VM_MAIN_SERVICE} | tr -d ' ')

    if [[ -z ${VM_MAIN_SERVICE} ]]; then
      VM_MAIN_SERVICE=""
    fi
  fi
}

#######################################
# Make arch.
# Globals:
#   VM_OS
#   VM_ARCH
# Outputs:
#   Windows or Linux archs to choose from.
#######################################
function arch() {
  local arch_lst

  arch_lst=("amd64" "i386" "multi-arch" "arm64" "armel")

  echo -e "\n\t\t***** Arch *****\n"

  if [[ ${VM_OS} == "Linux" ]]; then
    for arch in $(seq 0 $(expr ${#arch_lst[@]} - 1)); do
      echo "[$(expr ${arch} + 1)] ${arch_lst[${arch}]}"
      arch+=1
    done

    echo ""; read -p "Enter arch [default none]: " VM_ARCH
    if [[ -z ${VM_ARCH} ]]; then
      :
    else
      check_is_number ${VM_ARCH}
    fi
    VM_ARCH=$(echo ${VM_ARCH} | tr -d ' ')

    for j in $(seq 0 $(expr ${#arch_lst[@]} - 1)); do
      case ${VM_ARCH} in
        $(expr ${j} + 1))
          VM_ARCH=${arch_lst[${j}]}
          break
          ;;
      esac
      j+=1
    done

    if [[ -z ${VM_ARCH} ]]; then
      VM_ARCH=""
    elif [[ -n ${VM_ARCH} ]]; then
      VM_ARCH=${VM_ARCH}
    fi
  elif [[ ${VM_OS} == "Windows" ]]; then
    echo -e "[1] x64\n[2] x86\n"
    read -p "Enter arch [default none]: " VM_ARCH
    if [[ -z ${VM_ARCH} ]]; then
      :
    else
      check_is_number ${VM_ARCH}
    fi
    VM_ARCH=$(echo ${VM_ARCH} | tr -d ' ')

    case ${VM_ARCH} in
      1)
        VM_ARCH="x64"
        ;;
      2)
        VM_ARCH="x86"
        ;;
    esac

    if [[ -z ${VM_ARCH} ]]; then
      VM_ARCH=""
    elif [[ -n ${VM_ARCH} ]]; then
      VM_ARCH=${VM_ARCH}
    fi
  else
    # If VM_OS is different from "Linux" or "Windows", a custom architecture for
    # the informed OS can be inserted.
    read -p "Enter arch to OS ${VM_OS}: " VM_ARCH
  fi
}

#######################################
# Make VM name.
# Globals:
#   VM_NAME
#   VM_TYPE
#   VM_ID
#   VM_DISTRO
#   VM_DISTRO_VERSION
#   VM_MAIN_SERVICE
#   VM_ARCH
# Outputs:
#   The VM name created.
#######################################
function vm_name() {
  if [[ ${VM_OS} == "Linux" ]]; then
    VM_NAME="${VM_TYPE}_${VM_DISTRO}_${VM_DISTRO_VERSION}_${VM_MAIN_SERVICE}_${VM_ARCH}_VMID_${VM_ID}"
  elif [[ ${VM_OS} == "Windows" ]]; then
    VM_NAME="${VM_TYPE}_${VM_OS}_${WIN_VERSION}_${VM_MAIN_SERVICE}_${VM_ARCH}_VMID_${VM_ID}"
  fi

  VM_NAME=$(echo ${VM_NAME} | tr [:lower:] [:upper:] | tr -s '_')
  echo "${VM_ID} ${VM_NAME}" >> ${FILE_PATH}
  echo -e "\nVM name: \033[01;32m${VM_NAME}\033[00m\n"

  # Checks whether the "xclip" tool is installed.
  dpkg -s xclip > /dev/null 2>&1
  if (( $? != 0 )); then
    echo -e "The xclip tool not installed. For convenience the name of the VM,"
    echo -e "after being generated, is automatically copied using this tool to"
    echo -e "the clipboard.\n"
    echo -e "Run following command to install:\n"
    echo -e "  sudo apt install xclip"
  else
    echo ${VM_NAME} | tr -d [:space:] | xclip -selection clipboard
    echo -e "VM name copied to the clipboard.\n"
  fi
}

#######################################
# Make HD type (dynamic or fixed).
# Globals:
#   HD_TYPE
# Outputs:
#   HD type for choice.
#######################################
function hd_type() {
  echo -e "\n\t\t***** HD type *****\n"
  echo -e "[1] Dynamically allocated storage\n[2] Fixedly allocated storage\n"
  read -p "Enter HD type [default none]: " HD_TYPE
  if [[ -z ${HD_TYPE} ]]; then
    :
  else
    check_is_number ${HD_TYPE}
  fi
  HD_TYPE=$(echo ${HD_TYPE} | tr -d ' ')

  case ${HD_TYPE} in
    1)
      HD_TYPE="dynamic"
      ;;
    2)
      HD_TYPE="fixed"
      ;;
  esac

  if [[ -z ${HD_TYPE} ]]; then
    HD_TYPE=""
  elif [[ -n ${HD_TYPE} ]]; then
    HD_TYPE=${HD_TYPE}
  fi
}

#######################################
# Make HD ID (hexedacimal format).
# Globals:
#   HD_ID
# Outputs:
#   None
#######################################
function hd_id() {
  HD_ID=$(openssl rand -hex 2)
}

#######################################
# Make HD size in GB.
# Globals:
#   HD_SIZE
# Outputs:
#   None
#######################################
function hd_size() {
  local is_number

  is_number='^[0-9]+([.][0-9]+)?$'

  echo -e "\n\t\t***** HD size *****\n"
  read -p "Enter size hard disk (GB): " HD_SIZE

  # Checks whether the entered value is a number and checks whether it is 0.
  if [[ -z ${HD_SIZE} ]]; then
    echo -e "\n\033[01;31mError:\033[00m HD size is null.\n"
    return 1
  elif ! [[ ${HD_SIZE} =~ ${is_number} ]]; then
    echo -e "\n\033[01;31mError:\033[00m HD size is not a number.\n"
    return 1
  elif [[ ${HD_SIZE} -le 0 ]]; then
    echo -e "\n\033[01;31mError:\033[00m HD size is 0 or less.\n"
    return 1
  fi
}

#######################################
# Make HD name associated with the created VM name.
# Globals:
#   FILE_PATH
#   HD_ID
#   HD_SIZE
#   HD_TYPE
# Outputs:
#   The created HD name.
#######################################
function hd_name_currently() {
  local last_vm_id
  local vm_id_currently
  local hd_name_currently

  last_vm_id=$(cat ${FILE_PATH} | egrep -ac "[0-9a-zA-Z]+ ")
  vm_id_currently=$(cat ${FILE_PATH} | sed "${last_vm_id}q;d" | cut -d " " -f 1)

  hd_name_currently="VMID_${vm_id_currently}_${HD_TYPE}_${HD_SIZE}GB_HDID_${HD_ID}"
  hd_name_currently=$(echo ${hd_name_currently} \
    | tr [:lower:] [:upper:] \
    | tr -s '_')
  echo -e "\nHD name: \033[01;32m${hd_name_currently}\033[00m\n"
}

#######################################
# Make the name of the HD to associate with another VM.
# It is not newly created.
# Globals:
#   VM_ID
#   VM_NAME
#   FILE_PATH
#   HD_ID
#   HD_SIZE
#   HD_TYPE
# Outputs:
#   The created HD name.
#######################################
function hd_name_not_currently() {
  local vm_id_assoc

  echo -e "\n\t\t***** VM ID associated with this hard disk *****\n"

  for j in $(seq 1 $(cat ${FILE_PATH} | egrep -ac "[0-9a-zA-Z]+ ")); do
    echo -e "[${j}] $(cat ${FILE_PATH} | sed "${j}q;d" | cut -d " " -f 1,2)"
    j+=1
  done

  echo ""; read -p "Enter VM ID associated: " vm_id_assoc
  check_is_number ${vm_id_assoc}

  for k in $(seq 1 $(wc -l ${FILE_PATH} | cut -d " " -f 1)); do
    case ${vm_id_assoc} in
      ${k})
        vm_id_assoc=$(cat ${FILE_PATH} | sed "${k}q;d" | cut -d " " -f 1)
        ;;
    esac
    k+=1
  done

  hd_type
  hd_id
  hd_size

  if (( $? != 0 )); then
    :
  else
    hd_name_not_currently="VMID_${vm_id_assoc}_${HD_TYPE}_${HD_SIZE}GB_HDID_${HD_ID}"
    hd_name_not_currently=$(echo ${hd_name_not_currently} \
      | tr [:lower:] [:upper:] \
      | tr -s '_')
    echo -e "\nHD name: \033[01;32m${hd_name_not_currently}\033[00m\n"

    # Checks whether the "xclip" tool is installed.
    dpkg -s xclip > /dev/null 2>&1
    if (( $? != 0 )); then
      echo -e "The xclip tool not installed. For convenience the name of the VM,"
      echo -e "after being generated, is automatically copied using this tool to"
      echo -e "the clipboard.\n"
      echo -e "Run following command to install:\n"
      echo -e "  sudo apt install xclip"
    else
      echo ${hd_name_not_currently} | tr -d [:space:] | xclip -selection clipboard
      echo -e "HD name copied to the clipboard.\n"
    fi
  fi
}

function main() {
  # Checks whether the jq tool is installed.
  dpkg -s jq > /dev/null 2>&1
  if (( $? != 0 )); then
    echo -e "The jq tool is not installed, the script makes use of this tool"
    echo -e "to read the named-vm.json file.\n"
    echo -e "Run the following command to install:\n"
    echo -e "  sudo apt install jq"
    exit 1
  else
    :
  fi

  vm_type
  vm_id
  os

  if [[ ${VM_OS} == "Linux" ]]; then
    linux_distro
    if [[ -z ${VM_DISTRO} ]]; then
      :
    else
      distro_version
    fi
  elif [[ ${VM_OS} == "Windows" ]]; then
    win_version
  fi

  main_service
  arch
  vm_name

  # To create an HD name associated with the name of the newly created VM.
  read -p "Create a hard disk name to associate with this VM [y/N]? " answer
  if [[ ${answer} != "y" ]]; then
    return 0
  else
    hd_type
    hd_id
    hd_size
    # In the hd_size function there is an input check: if the input is 0,
    # null or not a number.
    if (( $? != 0 )); then
      :
    else
      hd_name_currently
    fi
  fi
}

case $1 in
  "-vm"|"--vm-name")
    main
    ;;
  "-hd"|"--hd-name")
    hd_name_not_currently
    ;;
  *)
    echo -e "Invalid option.\n"
    echo -e "Usage: ./named-vm.sh [option]\n"
    echo -e "Options:"
    echo -e " -vm, --vm-name        Create VM name. This can also create an HD"
    echo -e "                       name at the end."
    echo -e " -hd, --hd-name        Create HD name."
    ;;
esac

unset VM_TYPE VM_ID VM_OS VM_DISTRO WIN_VERSION VM_DISTRO_VERSION
unset VM_MAIN_SERVICE VM_ARCH VM_NAME HD_SIZE HD_TYPE FILE_PATH HD_ID
unset num_of_distro num_of_version distro num_of_version_stt num_of_version_srv
unset arch_lst hd_name vm_id_assoc last_vm_id hd_name_currently
