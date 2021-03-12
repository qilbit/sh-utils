#!/bin/bash
### BEGIN INIT INFO
# Description:      Synchronizes files ~/.bash_aliases, ~/.bashrc,
#                   ~/.profile, ~/.vimrc and the directory ~/.vim between hosts and
#                   VMs. Also used to synchronize files /etc/hosts e
#                   /etc/networks.
#
#                   The synchronization of files between host and VM was done
#                   considering the use for VirtualBox. Therefore the VBox
#                   'Shared Folders' feature must be enabled and configured as
#                   follows:
#
#                   Name       Path            Access Auto Mount At
#                   sync-files /tmp/sync-files Full   Yes  /tmp/sync-files
### END INIT INFO
#
# Author:           Rafael Mendes <rafaelmendes.dev@gmail.com>

DIR_SYNC_FILES="/tmp/sync-files"

# The /tmp/sync-files directory must be configured in the 'tmp' directory
if [[ -d /tmp/sync-files ]]; then
    :
else
    mkdir /tmp/sync-files
fi

# Virtual machine: VM_OR_HOST=vm
# Host: VM_OR_HOST=desktop
VM_OR_HOST=$(hostnamectl | grep "Chassis" | tr -d ' ' | cut -d ':' -f 2)

MSG_COPY_SUCCESS="Copiado com sucesso! \n"
MSG_CAT_SUCCESS="Conteúdo sobrescrito com sucesso! \n"

###############################################################################
#                                     TEST                                    #
###############################################################################
# function host() {
#     if [[ ${VM_OR_HOST} == "vm" ]]; then
#         echo "O comando 'cp-dot-host' deve ser usado para copiar os arquivos " \
#         "\"dot\" da home do usuário na máquina host para o diretório '${DIR_SYNC_FILES}'."
#     else
#         # Cria o arquivo ~/bash_aliases, se não existir.
#         if [[ -f ~/.bash_aliases ]]; then
#             :
#         else
#             touch ~/.bash_aliases
#
#         fi
#
#         # Cria o arquivo ~/vimrc, se não existir.
#         if [[ -f ~/.vimrc ]]; then
#             :
#         else
#             touch ~/.vimrc
#         fi
#
#         # Cria o diretório  ~/vim, se não existir.
#         if [[ -d ~/.vimrc ]]; then
#             :
#         else
#             mkdir ~/.vim
#         fi
#
#         echo "Copiando ~/.bash_aliases para ${DIR_SYNC_FILES}"
#         cp -vp ~/.bash_aliases ${DIR_SYNC_FILES}
#         if [[ "$?" -eq 0 ]]; then
#             echo -e ${MSG_COPY_SUCCESS}
#         fi
#
#         echo "Copiando ~/.bashrc para ${DIR_SYNC_FILES}"
#         cp -vp ~/.bashrc ${DIR_SYNC_FILES}
#         if [[ "$?" -eq 0 ]]; then
#             echo -e ${MSG_COPY_SUCCESS}
#         fi
#
#         echo "Copiando ~/.profile para ${DIR_SYNC_FILES}"
#         cp -vp ~/.profile ${DIR_SYNC_FILES}
#         if [[ "$?" -eq 0 ]]; then
#             echo -e ${MSG_COPY_SUCCESS}
#         fi
#
#         echo "Copiando ~/.vimrc para ${DIR_SYNC_FILES}"
#         cp -vp ~/.vimrc ${DIR_SYNC_FILES}
#         if [[ "$?" -eq 0 ]]; then
#             echo -e ${MSG_COPY_SUCCESS}
#         fi
#
#         echo "Copiando ~/.vim para ${DIR_SYNC_FILES}"
#         cp -rvp ~/.vim ${DIR_SYNC_FILES}
#         if [[ "$?" -eq 0 ]]; then
#             echo -e ${MSG_COPY_SUCCESS}
#         fi
#     fi
# }

###############################################################################
# Copy the "dot" files from the user's home on the host machine and VMs to
# /tmp/sync-files.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
###############################################################################
function cp_dot() {
    case "$2" in
        host)
            if [[ ${VM_OR_HOST} == "vm" ]]; then
                echo "O comando 'cp-dot-host' deve ser usado para copiar os arquivos " \
                "\"dot\" da home do usuário na máquina host para o diretório '${DIR_SYNC_FILES}'."
            else
                # Creates the ~/.bash_aliases file, if it does not exist.
                if [[ -f ~/.bash_aliases ]]; then
                    :
                else
                    touch ~/.bash_aliases

                fi

                # Creates the ~/.vimrc file, if it does not exist.
                if [[ -f ~/.vimrc ]]; then
                    :
                else
                    touch ~/.vimrc
                fi

                # Create the ~/.vim directory, if it does not exist.
                if [[ -d ~/.vimrc ]]; then
                    :
                else
                    mkdir ~/.vim
                fi

                echo "Copiando ~/.bash_aliases para ${DIR_SYNC_FILES}"
                cp -vp ~/.bash_aliases ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.bashrc para ${DIR_SYNC_FILES}"
                cp -vp ~/.bashrc ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.profile para ${DIR_SYNC_FILES}"
                cp -vp ~/.profile ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.vimrc para ${DIR_SYNC_FILES}"
                cp -vp ~/.vimrc ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.vim para ${DIR_SYNC_FILES}"
                cp -rvp ~/.vim ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi
            fi
            ;;
        vm)
            if [[ ${VM_OR_HOST} == "desktop" ]]; then
                echo "O comando 'cp-dot-vm' deve ser usado para copiar os arquivos " \
                "\"dot\" da home do usuário na VM para o diretório '${DIR_SYNC_FILES}'."
            else
                # Creates the ~/.bash_aliases file, if it does not exist.
                if [[ -f ~/.bash_aliases ]]; then
                    :
                else
                    touch ~/.bash_aliases

                fi

                # Creates the ~/.vimrc file, if it does not exist.
                if [[ -f ~/.vimrc ]]; then
                    :
                else
                    touch ~/.vimrc
                fi

                # Create the ~/.vim directory, if it does not exist.
                if [[ -d ~/.vimrc ]]; then
                    :
                else
                    mkdir ~/.vim
                fi

                echo "Copiando ~/.bash_aliases para ${DIR_SYNC_FILES}"
                cp -vp ~/.bash_aliases ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.bashrc para ${DIR_SYNC_FILES}"
                cp -vp ~/.bashrc ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.profile para ${DIR_SYNC_FILES}"
                cp -vp ~/.profile ${IR_IN_VM}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.vimrc para ${DIR_SYNC_FILES}"
                cp -vp ~/.vimrc ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando ~/.vim para ${DIR_SYNC_FILES}"
                cp -rvp ~/.vim ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi
            fi
            ;;
    esac
}

###############################################################################
# Copy the contents of the "dot" files in /tmp/sync-files to the user's home on
# the host machine and VMs.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
###############################################################################
function cat_dot() {
    case "$2" in
        host)
            if [[ ${VM_OR_HOST} == "vm" ]]; then
                echo "O comando 'cat-dot-host' deve ser usado para inserir o conteúdo " \
                "dos arquivos \"dot\" do diretório '${DIR_SYNC_FILES}' nas na home do " \
                "usuário da máquina host."
            else
                echo "Sobrescrevendo conteúdo de ~/.bash_aliases"
                cat "${DIR_SYNC_FILES}/.bash_aliases" > ~/.bash_aliases && \
                chmod 644 ~/.bash_aliases
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.bashrc"
                cat "${DIR_SYNC_FILES}/.bashrc" > ~/.bashrc && \
                chmod 644 ~/.bashrc
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.profile"
                cat "${DIR_SYNC_FILES}/.profile" > ~/.profile && \
                chmod 644 ~/.profile
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.vimrc"
                cat "${DIR_SYNC_FILES}/.vimrc" > ~/.vimrc && \
                chmod 644 ~/.vimrc
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.vim"
                cp -rvp "${DIR_SYNC_FILES}/.vim" ~/.vim && \
                chmod -R 755 ~/.vim
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi
            fi
            ;;
        vm)
            if [[ ${VM_OR_HOST} == "desktop" ]]; then
                echo "O comando 'cat-dot-vm' deve ser usado para inserir o conteúdo " \
                "dos arquivos \"dot\" do diretório '${DIR_SYNC_FILES}' nas na home do " \
                "usuário da VM."
            else
                echo "Sobrescrevendo conteúdo de ~/.bash_aliases"
                cat "${DIR_SYNC_FILES}/.bash_aliases" > ~/.bash_aliases && \
                chmod 644 ~/.bash_aliases
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.bashrc"
                cat "${DIR_SYNC_FILES}/.bashrc" > ~/.bashrc && \
                chmod 644 ~/.bashrc
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.profile"
                cat "${DIR_SYNC_FILES}/.profile" > ~/.profile && \
                chmod 644 ~/.profile
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.vimrc"
                cat "${DIR_SYNC_FILES}/.vimrc" > ~/.vimrc && \
                chmod 644 ~/.vimrc
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de ~/.vim"
                cp -rvp "${DIR_SYNC_FILES}/.vim" ~/.vim && \
                chmod 755 ~/.vim
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi
            fi
            ;;
    esac
}

###############################################################################
# Copy the "conf" files from the host machine and VMs to /tmp/sync-files.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
###############################################################################
function cp_conf() {
    case "$2" in
        host)
            if [[ ${VM_OR_HOST} == "vm" ]]; then
                echo "O comando 'cp-conf-host' deve ser usado para copiar os arquivos " \
                "\"conf\" da máquina host para o diretório '${DIR_SYNC_FILES}'."
            else
                echo "Copiando /etc/hosts para ${DIR_SYNC_FILES}"
                cp -vp /etc/hosts ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando /etc/networks para ${DIR_SYNC_FILES}"
                cp -vp /etc/networks ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi
            fi
            ;;
        vm)
            if [[ ${VM_OR_HOST} == "desktop" ]]; then
                echo "O comando 'cp-conf-vm' deve ser usado para copiar os arquivos " \
                "\"conf\" da VM para o diretório '${DIR_SYNC_FILES}'."
            else
                echo "Copiando /etc/hosts para ${DIR_SYNC_FILES}"
                cp -vp /etc/hosts ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi

                echo "Copiando /etc/networks para ${DIR_SYNC_FILES}"
                cp -vp /etc/networks ${DIR_SYNC_FILES}
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_COPY_SUCCESS}
                fi
            fi
            ;;
    esac
}

###############################################################################
# Copies the contents of the "conf" files in /tmp/sync-files to the
# the host machine and VMs.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
###############################################################################
function cat_conf() {
    case "$2" in
        host)
            if [[ ${VM_OR_HOST} == "vm" ]]; then
                echo "O comando 'cat-conf-host' deve ser usado para inserir o conteúdo " \
                "dos arquivos \"conf\" do diretório '${DIR_SYNC_FILES}' " \
                "na máquina host."
            else
                echo "Sobrescrevendo conteúdo de /etc/hosts"
                sudo cat ${DIR_SYNC_FILES}/hosts > /etc/hosts
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de /etc/networks"
                sudo cat ${DIR_SYNC_FILES}/networks > /etc/networks
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi
            fi
            ;;
        vm)
            if [[ ${VM_OR_HOST} == "desktop" ]]; then
                echo "O comando 'cat-conf-vm' deve ser usado para inserir o conteúdo " \
                "dos arquivos \"conf\" do diretório '${DIR_SYNC_FILES}' na VM."
            else
                echo "Sobrescrevendo conteúdo de /etc/hosts"
                sudo cat ${DIR_SYNC_FILES}/hosts > /etc/hosts
                if [[ "$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi

                echo "Sobrescrevendo conteúdo de /etc/networks"
                sudo cat ${DIR_SYNC_FILES}/networks > /etc/networks
                if [[ 8"$?" -eq 0 ]]; then
                    echo -e ${MSG_CAT_SUCCESS}
                fi
            fi
            ;;
    esac
}

case "$1" in
    cp-dot)
        cp_dot
        ;;
    cat-dot)
        cat_dot
        ;;
    cp-conf)
        cp_conf
        ;;
    cat-conf)
        cat_conf
        ;;
    *)
        echo -e "Usage: $0 [command] [destination]

Commands:
  cp-conf    Copia os arquivos conf ou dot para o diretório ${DIR_SYNC_FILES}
  cp-dot     no destino.

  cat-conf   Sobrescreve o conteúdo dos arquivos no destino especificado.
  cat-dot

Destination:
  host       Copia ou sobrescreve o conteúdo dos arquivos para o host.
             Quando usado com cp-[dot|conf], copia os arquivos
             para ${DIR_SYNC_FILES} na máquina host.
             Quando usado com cat-[dot|conf], sobrescreve o conteúdo
             dos arquivos na máquina host.

  vm         Copia ou sobrescreve o conteúdo dos arquivos para a VM.
             Quando usado com cp-[dot|conf], copia os arquivos
             para ${DIR_SYNC_FILES} na VM.
             Quando usado com cat-[dot|conf], sobrescreve o conteúdo
             dos arquivos na VM."
        ;;
esac
