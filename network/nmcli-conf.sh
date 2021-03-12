#!/bin/env bash
### BEGIN INIT INFO
# Short-Description: Delete or create new network connections with nmcli
#                    interactively. Facilitates the method of creating network
#                    connections with the NetworkManager nmcli command line
#                    tool.
#
# Description:       To create a new connection it is necessary to provide:
#
#                      - Connection name (optional)
#                      - The interface (e.g. eth0)
#                      - The IPv4 address (CIDR notation)
#
#                    The gateway and DNS can be defined in the script using
#                    the "gw" and "dns" variables. The script was written with
#                    a view to standardizing and automating the creation of
#                    connections in VMs for the study laboratory.
### END INIT INFO
#
# Author:            Rafael Mendes <rafaelmendes.dev@gmail.com>
#

#######################################
# Adds a new connection.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#  A connection added.
#######################################
function add_con() {
  local con_name
  local number_of_iface
  local if_name
  local ip4
  local active_con
  local posfix_number_con
  local gw
  local dns

  number_of_iface=$(ip token list | cut -d " " -f 4 | wc -l)
  posfix_number_con=$(nmcli -g NAME con \
    | egrep "Ethernet connection [0-9]" \
    | sort \
    | tail -n 1 \
    | cut -d " " -f 3)
  gw="10.10.10.1"
  dns="8.8.8.8,8.8.4.4"

  echo -e "\nAdds a new connection.\n"

  read -p "Connection name [if empty the default name is used]: " con_name

  # Name the new associations with "Ethernet connection [number]", where
  # "number" is informative of the sum between the number of the previous
  # connection plus one.
  if [[ -z ${con_name} ]]; then
    con_name="Ethernet connection $(expr ${posfix_number_con} + 1)"
    echo -e "Assigned default name: ${con_name}"
  fi

  # Displays a numbered list of interface names found.
  echo -e "\nFound interfaces:\n"
  for iface in $(seq ${number_of_iface}); do
    echo "[${iface}] $(ip token list \
    | cut -d " " -f 4 \
    | tr "\n" ":" \
    | cut -d ":" -f ${iface})"

    # When the "iface" variable becomes equal to the number of interfaces found,
    # it means that a list of interfaces is already known.
    if [[ ${iface} -eq ${number_of_iface} ]]; then
      echo ""
      read -p "Interface 1-${number_of_iface} [1]: " if_name

      for iface in $(seq ${number_of_iface}); do
        # If the value of the variable "if_name" is equal to the value of
        # "iface" the variable "if_name" will receive the name of the interface
        # that is associated with the chosen interface number.
        if [[ ${if_name} -eq ${iface} ]]; then
          if_name=$(ip token list \
  		      | cut -d " " -f 4 \
  		      | tr "\n" ":" \
  		      | cut -d ":" -f ${iface})
          echo -e "Selected interface: ${if_name}\n"
    	  elif [[ -z ${if_name} ]]; then
  	      # If an option is chosen outside the range of existing interfaces,
          # interface number 1 is selected.
          if [[ ${if_name} -ne ${iface} ]]; then
            if_name=$(ip token list \
  			       | cut -d " " -f 4 \
  			       | tr "\n" ":" \
  			       | cut -d ":" -f 1)
            echo -e "Selected interface: ${if_name}\n"
          fi
        fi
      done
    fi
  done

  # IPv4 address with CIDR notation (e.g., 10.0.0.100/16).
  read -p "IPv4 address (CIDR notation): " ip4

  # Adding the new connection.
  nmcli con add con-name ${con_name} ifname ${if_name} type ethernet ipv4.addresses ${ip4} ipv4.gateway ${gw} ipv4.dns ${dns}

  if [[ "$?" -eq 0 ]]; then
    echo -e "\nConnection added successfully.\n"
  else
    echo -e "An error occurred while trying to add the new connection.\n"
  fi

  # Activates the created connection.
  read -p "Activate the connection? [Y/n]: " active_con
  if [[ ${active_con} = "Y" ]] || [[ ${active_con} = "y" ]]; then
    nmcli con up ${con_name}
    echo -e "\e[1;32mConnection enabled.\e[0m\n"
  elif [[ -z ${active_con} ]]; then
    nmcli con up ${con_name}
    echo -e "\e[1;32mConnection enabled.\e[0m\n"
  fi

  # Displays connections.
  sleep 0.5
  nmcli con show
}

function del_con() {
    local number_of_con=$(nmcli -g NAME con | wc -l)
    local con_name

    # Se o número de conexões for igual a zero, encerra o script com exit code 0.
    if [ "$number_of_con" -eq 0 ]; then
        echo "Não há conexão(ões). Saindo..."; sleep 0.5
	exit 0
    else
        # Exibe uma lista, numerada, de nomes de conexões existentes.
        echo "Conexões existentes."
        for number_con in $(seq "$number_of_con"); do
	    echo "  $number_con - $(nmcli -g NAME con \
		    | tr "\n" ":" \
		    | cut -d ":" -f $number_con)"

            # Quando a variável number_con se torna igual ao valor máximo (número de
	    # conexões existentes), significa que a lista de conexões já
	    # é conhecida, assim é possível escolher a conexão a partir do
	    # número associado (exibindo a opção de escolha da interface).
	    if [ $number_con -eq "$number_of_con" ]; then
	        echo ""
	        read -p "Escolha 1-$number_of_con [1]: " con_name
	        for number_con in $(seq "$number_of_con"); do
		    # Apaga a conexão associada ao número escolhido.
	            if [ "$con_name" == "$number_con" ]; then
		        con_name=$(nmcli -g NAME con \
				| tr "\n" ":" \
				| cut -d ":" -f $number_con)
			echo "Apagando..."
			nmcli con del "$con_name"
		    # Apaga todas as conexões existentes.
		    elif [ "$con_name" == "all" ]; then
		        for number_con in $(seq "$number_of_con"); do
		            con_name=$(nmcli -g NAME con \
				    | head -n 1)
			    echo "Apagando..."
			    nmcli con del "$con_name"
		        done
		    # Por padrão apaga a conexão de número 1 da lista,
		    # caso nenhuma seja selecionada.
		    elif [ "$con_name" == "" ]; then
		        con_name=$(nmcli -g NAME con \
				| tr "\n" ":" \
				| cut -d ":" -f 1)
		        echo -e "Apagando...\n"
			nmcli con del "$con_name"
		    fi
	        done
            fi
        done
    fi

    # Exibe as conexões.
    sleep 0.5
    nmcli con show
}

function msg_nm_installed() {
  echo -e "\nThe \"network-manager\" package is not installed."
  echo -e "The script requires the \"nmcli\" command-line tool.\n"
  echo -e "Run the following command to install."
  echo -e "\"sudo apt install network-manager\"\n"
}

case "$1" in
  add)
    dpkg -s network-manager > /dev/null 2>&1
    if [ "$?" -eq 0 ]; then
      add_con
    else
      msg_nm_installed
    fi
	  ;;
  del)
    dpkg -s network-manager > /dev/null 2>&1
    if [ "$?" -eq 0 ]; then
      del_con
    else
      msg_nm_installed
    fi
	  ;;
  *)
    echo -e "\nUsage: ./nmcli-conf.sh {add | del}\n"
	  echo -e "Commands:\n"
	  echo "  add          Adds a new connection."
	  echo "  del          Delete an existing connection."
    echo ""
    ;;
esac
