#!/bin/bash
#
# Private IP Tunnel Configuration Scripr
# Tunnel Author : github.com/radkesvat
# Author: github.com/Azumi67
#
# This script is designed to simplify the installation and configuration of RTT with Native/Private ip.
# Tested on Ubuntu 20 - Debian 12
#
# Usage:
#   - Run the script with root privileges.
#   - Follow the on-screen prompts to install, configure, or uninstall the tunnel.
#
#
# Disclaimer:
# This script comes with no warranties or guarantees. Use it at your own risk.
if [[ $EUID -ne 0 ]]; then
  echo -e "\e[93mThis script must be run as root. Please use sudo -i.\e[0m"
  exit 1
fi

# bar
function display_progress() {
  local total=$1
  local current=$2
  local width=40
  local percentage=$((current * 100 / total))
  local completed=$((width * current / total))
  local remaining=$((width - completed))

  printf '\r['
  printf '%*s' "$completed" | tr ' ' '='
  printf '>'
  printf '%*s' "$remaining" | tr ' ' ' '
  printf '] %d%%' "$percentage"
}
function stop_loading() {
  echo -e "\r\xE2\x98\xBA \e[91mService activation stopped.\e[0m ~"
  return
}
# baraye checkmark
function display_checkmark() {
  echo -e "\xE2\x9C\x94 $1"
}

# error msg
function display_error() {
  echo -e "\xE2\x9D\x8C Error: $1"
}

# notify
function display_notification() {
  echo -e "\xE2\x9C\xA8 $1"
}
function display_loading() {
  local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local delay=0.1
  local duration=3  

  local end_time=$((SECONDS + duration))

  while ((SECONDS < end_time)); do
    for frame in "${frames[@]}"; do
      printf "\r%s Loading...  " "$frame"
      sleep "$delay"
      printf "\r%s             " "$frame"
      sleep "$delay"
    done
  done

  echo -e "\r\xE2\x98\xBA \e[91mService activated successfully!\e[0m ~"
}
#logo
function display_logo() {
echo -e "\033[1;96m$logo\033[0m"
}
#logo2
function display_logoo() {
    echo -e "\e[92m$logoo\e[0m"
}
#art2
logoo=$(cat << "EOF"

  _____       _     _      
 / ____|     (_)   | |     
| |  __ _   _ _  __| | ___ 
| | |_ | | | | |/ _` |/ _ \
| |__| | |_| | | (_| |  __/
 \_____|\__,_|_|\__,_|\___|
EOF
)
# art
logo=$(cat << "EOF"
⠀⠀               ⠄⠠⠤⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀⠀⢀⠠⢀⣢⣈⣉⠁⡆⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⡏⢠⣾⢷⢶⣄⣕⠢⢄⠀⠀⣀⣠⠤⠔⠒⠒⠒⠒⠒⠒⠢⠤⠄⣀⠤⢊⣤⣶⣿⡿⣿⢹⢀⡇⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⢻⠈⣿⢫⡞⠛⡟⣷⣦⡝⠋⠉⣤⣤⣶⣶⣶⣿⣿⣿⡗⢲⣴⠀⠈⠑⣿⡟⡏⠀⢱⣮⡏⢨⠃⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⠸⡅⣹⣿⠀⠀⢩⡽⠋⣠⣤⣿⣿⣏⣛⡻⠿⣿⢟⣹⣴⢿⣹⣿⡟⢦⣀⠙⢷⣤⣼⣾⢁⡾⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀             ⠀⢻⡀⢳⣟⣶⠯⢀⡾⢍⠻⣿⣿⣽⣿⣽⡻⣧⣟⢾⣹⡯⢷⡿⠁⠀⢻⣦⡈⢿⡟⠁⡼⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀             ⠀⢷⠠⢻⠏⢰⣯⡞⡌⣵⠣⠘⡉⢈⠓⡿⠳⣯⠋⠁⠀⠀⢳⡀⣰⣿⣿⣷⡈⢣⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀             ⠀⠀⠙⣎⠀⣿⣿⣷⣾⣷⣼⣵⣆⠂⡐⢀⣴⣌⠀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣷⣀⠣⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀            ⠀⠀  ⠄⠑⢺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣳⣿⢽⣧⡤⢤⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀            ⠀⠀  ⢸⣈⢹⣟⣿⣿⣿⣿⣿⣻⢹⣿⣻⢿⣿⢿⣽⣳⣯⣿⢷⣿⡷⣟⣯⣻⣽⠧⠾⢤⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀             ⠀ ⢇⠤⢾⣟⡾⣽⣿⣽⣻⡗⢹⡿⢿⣻⠸⢿⢯⡟⡿⡽⣻⣯⣿⣎⢷⣣⡿⢾⢕⣎⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀             ⠀⡠⡞⡟⣻⣮⣍⡛⢿⣽⣻⡀⠁⣟⣣⠿⡠⣿⢏⡞⠧⠽⢵⣳⣿⣺⣿⢿⡋⠙⡀⠇⠱⠀⠀⠀
⠀⠀⠀             ⠀⢰⠠⠁⠀⢻⡿⣛⣽⣿⢟⡁\033[1;91m⣭⣥⣅⠀⠀⠀⠀⠀⠀⣶⣟⣧\033[1;96m⠿⢿⣿⣯⣿⡇⠀⡇⠀⢀⡇⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⠀⢸⠀⠀⡇⢹⣾⣿⣿⣷⡿⢿\033[1;91m⢷⡏⡈⠀⠀⠀⠀⠀⠀⠈⡹⡷⡎\033[1;96m⢸⣿⣿⣿⡇⠀⡇⠀⠸⡇⠀⠀⠀⠀⠀⠀
⠀             ⠀⠀⠀⢸⡄⠂⠖⢸⣿⣿⣿⡏⢃⠘\033[1;91m⡊⠩⠁⠀⠀⠀⠀⠀⠀⠀⠁⠀⠁\033[1;96m⢹⣿⣿⣿⡇⢰⢁⡌⢀⠇⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⠀⠀⢷⡘⠜⣤⣿⣿⣿⣷⡅⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣧⣕⣼⣠⡵⠋⠀⠀⠀⠀⠀⠀⠀
⠀⠀              ⠀⠀⠀⣸⣻⣿⣾⣿⣿⣿⣿⣾⡄⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⢀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀             ⠀⠀⡇⣿⣻⣿⣿⣿⣿⣿⣿⣿⣦⣤⣀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣳⣿⡸⡀ ⡇ \e[32mTunnel Author : github.com/radkesvat  \033[1;96m⡇  
⠀⠀             ⠀⠀\033[1;96m⣸⢡⣿⢿⣿⣿⣿⣿⣿⣿⣿⢿⣿⡟⣽⠉⠀⠒⠂⠉⣯⢹⣿⡿⣿⣿⣿⣿⣿⣯⣿⡇⠇ ⡇ \e[32mAuthor: github.com/Azumi67  \033[1;96m⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀\033[1;96m⢰⡏⣼⡿⣿⣻⣿⣿⣿⣿⣿⢿⣻⡿⠁⠘⡆⠀⠀⠀⢠⠇⠘⣿⣿⣽⣿⣿⣿⣿⣯⣿⣷⣸⠀⠀ ⠀⠀⠀⠀
  \033[1;96m  ______   \033[1;94m _______  \033[1;92m __    \033[1;93m  _______     \033[1;91m   __      \033[1;96m _____  ___  
 \033[1;96m  /    " \  \033[1;94m|   __ "\ \033[1;92m|" \  \033[1;93m  /"      \    \033[1;91m  /""\     \033[1;96m(\"   \|"  \ 
 \033[1;96m // ____  \ \033[1;94m(. |__) :)\033[1;92m||  |  \033[1;93m|:        |   \033[1;91m /    \   \033[1;96m |.\\   \     |
 \033[1;96m/  /    ) :)\033[1;94m|:  ____/ \033[1;92m|:  |  \033[1;93m|_____/   )  \033[1;91m /' /\  \   \033[1;96m|: \.   \\   |
\033[1;96m(: (____/ // \033[1;94m(|  /     \033[1;92m|.  |  \033[1;93m //      /  \033[1;91m //  __'  \  \033[1;96m|.  \    \  |
 \033[1;96m\        / \033[1;94m/|__/ \    \033[1;92m/\  |\ \033[1;93m|:  __   \  \033[1;91m/   /  \\   \ \033[1;96m|    \    \ |
 \033[1;96m \"_____/ \033[1;94m(_______)  \033[1;92m(__\_|_)\033[1;93m|__|  \___)\033[1;91m(___/    \___) \033[1;96m\___|\____\)
EOF
)
function main_menu() {
    while true; do
        display_logo
        echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"  
        echo -e "\e[93m║           ▌║█║▌│║▌│║▌║▌█║ \e[92mMain Menu\e[93m  ▌│║▌║▌│║║▌█║▌             ║\e[0m"   
        echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m" 
        display_service_status                                 
        echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"
        echo -e   "\e[91m    ������ \e[92mJoin Opiran Telegram \e[34m@https://t.me/OPIranClub\e[0m \e[91m������\e[0m"
        echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m" 
        echo -e "1. \e[96mInstallation\e[0m"                                 
        echo -e "2. \e[92mRTT + Private IP Tunnel\e[0m"                                                 
        echo -e "3. \e[93mRTT + Native IPV6\e[0m"                                            
        echo -e "4. \e[36mStart/Stop - Restart Service\e[0m"                                                             
        echo -e "5. \e[91mUninstall\e[0m"                                                  
        echo "0. Exit"                                                             
        printf "\e[93m╰─────────────────────────────────────────────────────────────────╯\e[0m\n" 
        read -e -p $'\e[5mEnter your choice:  \e[0m' choice


        case $choice in
            1)
                installation_menu 
                ;;
			2)
                rtt-private
                ;;				
            3)
                rtt_native
                ;;
            4)
                restart_service
                ;;
            5)
                uninstall
                ;;
            0)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac

        echo "Press Enter to continue..."
        read
        clear
    done
}
function display_service_status() {
  sudo systemctl is-active Radkesvatkharej.service &>/dev/null
  local frpc_status=$?
  if [[ $frpc_status -eq 0 ]]; then
    frpc_status_msg="\e[92m\xE2\x9C\x94 RTT Kharej service is running\e[0m"
  else
    frpc_status_msg="\e[91m\xE2\x9C\x98 RTT Kharej service is not running\e[0m"
  fi

  sudo systemctl is-active Radkesvatiran.service &>/dev/null
  local frps_status=$?
  if [[ $frps_status -eq 0 ]]; then
    frps_status_msg="\e[92m\xE2\x9C\x94 RTT Iran service is running\e[0m"
  else
    frps_status_msg="\e[91m\xE2\x9C\x98 RTT Iran service is not running\e[0m"
  fi

  # FRP service status
  printf "\e[93m         ╭───────────────────────────────────────╮\e[0m\n"
  printf "\e[93m             %-35b \e[0m\n" "$frpc_status_msg"     
  printf "\e[93m             %-35b \e[0m\n" "$frps_status_msg"
  printf "\e[93m         ╰───────────────────────────────────────╯\e[0m\n"
}

function uninstall() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mUninstall Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
	echo ""
	printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mSelect what to uninstall:\e[0m'
  echo $'1. \e[92mPrivate IP\e[0m'
  echo $'2. \e[93mRTT\e[0m'
  echo $'3. \e[91mExtra Native ip\e[0m'
  echo $'4. \e[94mback to main menu\e[0m'
	printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"

  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
        1)
            pri_uninstall_menu
            ;;
        2)
            rtt_uninstall_menu
            ;;
		3)  
		    extra_uninstall_menu
            ;;			
        4)
            clear            
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}
function pri_uninstall_menu() {
   display_notification $'\e[93mRemoving private IP addresses..\e[0m'

    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi
    display_notification $'\e[93mRemoving cron job..\e[0m'
    crontab -l | grep -v "@reboot /bin/bash /etc/private.sh" | crontab -
 
		sleep 1
		systemctl disable ping_v6.service > /dev/null 2>&1
        systemctl stop ping_v6.service > /dev/null 2>&1
		rm /etc/systemd/system/ping_v6.service > /dev/null 2>&1
        sleep 1

    systemctl daemon-reload

    ip link set dev azumi down > /dev/null
    ip tunnel del azumi > /dev/null
	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
function rtt_uninstall_menu() {
    clear
    systemctl stop Radkesvatkharej > /dev/null 2>&1
    systemctl disable Radkesvatkharej > /dev/null 2>&1
	rm /etc/systemd/system/Radkesvatkharej.service > /dev/null 2>&1
	sleep 1
	systemctl stop Radkesvatiran > /dev/null 2>&1
    systemctl disable Radkesvatiran > /dev/null 2>&1
	rm /etc/systemd/system/Radkesvatiran.service > /dev/null 2>&1
    
	
    display_notification $'\e[93mRemoving RTT, Working in the background..\e[0m'

    echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mRTT removed successfully!\e[0m'
}
function extra_uninstall_menu() {
    clear
	echo "Uninstalling ..."

interface=$(ip route | awk '/default/ {print $5; exit}')


ip addr show dev $interface | awk '/inet6 .* global/ {print $2}' | while read -r address; do
    ip addr del "$address" dev $interface
done

# service
sudo systemctl stop ipv6.service
sudo systemctl disable ipv6.service
sudo rm /etc/systemd/system/ipv6.service
sudo systemctl daemon-reload

# script
sudo rm /etc/ipv6_setup.sh
display_notification $'\e[93mRemoving Extra ip, Working in the background..\e[0m'

    echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mExtra ip removed successfully!\e[0m'

}

function restart_service() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mRestart Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
	echo ""
	printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo $'\e[93mSelect what to Restart:\e[0m'
    echo $'1. \e[92mStart/Restart RTT\e[0m'
    echo $'2. \e[93mStop RTT\e[0m'
    echo $'3. \e[94mback to main menu\e[0m'
	printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
    case $server_type in
        1)
            rttres_menu
            ;;
        2)
            rttstop_menu
            ;;
        3)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}
function rttres_menu() {
  clear
  display_notification $'\e[93mRestarting RTT service...\e[0m'
    # Check 1
    systemctl daemon-reload
    systemctl restart Radkesvatkharej.service > /dev/null 2>&1
	systemctl restart Radkesvatiran.service > /dev/null 2>&1


  display_checkmark $'\e[92mRTT service restarted successfully!\e[0m'
  sleep 2
}
function rttstop_menu() {
  clear
  display_notification $'\e[93mStopping RTT service...\e[0m'
    # Check 2
    systemctl daemon-reload
    systemctl stop Radkesvatiran.service > /dev/null 2>&1
	systemctl stop Radkesvatkharej.service > /dev/null 2>&1


  display_checkmark $'\e[92mRTT service stopped successfully!\e[0m'
  sleep 2
}

function installation_menu() {
    
    function stop_loading() {
        echo -e "\xE2\x9D\x8C Installation process interrupted."
        exit 1
    }

    # (Ctrl+C)
    trap stop_loading INT
ipv4_forwarding=$(sysctl -n net.ipv4.ip_forward)
    if [[ $ipv4_forwarding -eq 1 ]]; then
        echo "IPv4 forwarding is already enabled."
    else

        sysctl -w net.ipv4.ip_forward=1 &>/dev/null
        echo "IPv4 forwarding has been enabled."
    fi

    ipv6_forwarding=$(sysctl -n net.ipv6.conf.all.forwarding)
    if [[ $ipv6_forwarding -eq 1 ]]; then
        echo "IPv6 forwarding is already enabled."
    else
        sysctl -w net.ipv6.conf.all.forwarding=1 &>/dev/null
        echo "IPv6 forwarding has been enabled."
    fi

    # DNS baraye install
    echo "nameserver 8.8.8.8" > /etc/resolv.conf

    # CPU architecture
    arch=$(uname -m)

    # cpu architecture
    case $arch in
        x86_64 | amd64)
            rtt_download_url="https://github.com/radkesvat/ReverseTlsTunnel/releases/download/V6.7/v6.7_linux_amd64.zip"
            ;;
        aarch64 | arm64)
            rtt_download_url="https://github.com/radkesvat/ReverseTlsTunnel/releases/download/V6.7/v6.7_linux_arm64.zip"
            ;;
        *)
            display_error "Unsupported CPU architecture: $arch"
            return
            ;;
    esac

    # Download FRP notificatiooooons
    display_notification $'\e[91mDownloading RTT in a sec...\e[0m'
    display_notification $'\e[91mPlease wait, updating...\e[0m'

    # timer
    SECONDS=0

    # Update in the background
    apt update &>/dev/null &
	apt install unzip -y &>/dev/null &
    apt_update_pid=$!

    # Timer
    while [[ -n $(ps -p $apt_update_pid -o pid=) ]]; do
        clear
        display_notification $'\e[93mPlease wait, updating...\e[0m'
        display_notification $'\e[93mAzumi is working in the background, timer: \e[0m'"$SECONDS seconds"
        sleep 1
    done

    # progress bar
    for ((i=0; i<=10; i++)); do
        sleep 0.5
        display_progress 10 $i
    done

    display_checkmark $'\e[92mUpdate completed successfully!\e[0m'

# Download 
    display_notification $'\e[91mDownloading RTT...\e[0m'
    wget "$rtt_download_url" -O rtt.zip &>/dev/null || display_error "Failed to download RTT"
    display_notification $'\e[92mRTT downloaded successfully!\e[0m'

    # Extract and move RTT
    display_notification $'\e[91mInstalling RTT...\e[0m'
    unzip -qq rtt.zip || display_error "Failed to extract RTT"
    rm rtt.zip
    chmod +x RTT

    display_notification $'\e[92mRTT installed successfully!\e[0m'

    # sysctl setting
    sysctl -p &>/dev/null

    # notify
    display_notification $'\e[92mIP forward enabled!\e[0m'
    display_loading

    # interrupt
    trap - INT
}
function rtt_native() {
clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mRTT + Native IP Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
	echo ""
echo -e "\e[93m.-------------------------------------------------------------------------------------------------------.\e[0m"
echo -e "\e[93m| \e[92mCreate extra native ipv6 for kharej, if it didn't work.. uninstall it and add extra ip manually \e[0m"
echo -e "\e[93m|\e[0m First establish the tunnel on iran server and then kharej                                              \e[0m"
echo -e "\e[93m'-------------------------------------------------------------------------------------------------------'\e[0m"
  printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mNative IP for kharej\e[0m'
  echo $'2. \e[93mKharej RTT Tunnel\e[0m'
  echo $'3. \e[0mIRAN RTT Tunnel\e[0m'
  echo $'4. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'Enter your choice Please: ' server_type
    
case $server_type in
    1)
        native_rtt_menu
        ;;
    2)
        kharejj_rtt_menu
        ;;
    3)
        irann_rtt_menu
        ;;
    4)
        clear
        main_menu
        ;;
    *)
        echo "Invalid choice."
        ;;
esac
}
function native_rtt_menu() {
  clear
  echo $'\e[92m ^ ^\e[0m'
  echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
  echo $'\e[92m(   ) \e[93mRTT + Native IP Menu\e[0m'
  echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
  echo ""
  echo -e "\e[93m.-------------------------------------------------------------------------------------------------------.\e[0m"
  echo -e "\e[93m| \e[92mIf it didn't work, please uninstall it and add extra IP manually  \e[0m"
  echo -e "\e[93m|\e[0m  If you don't have native IPv6, please use a private IP instead.                                             \e[0m"
  echo -e "\e[93m'-------------------------------------------------------------------------------------------------------'\e[0m"
  display_notification $'\e[93mAdding extra Native IPV6 [Kharej]...\e[0m'
  printf "\e[93m╭──────────────────────────────────────────────────────────╮\e[0m\n"

  # interface
  interface=$(ip route | awk '/default/ {print $5; exit}')
  ipv6_addresses=($(ip -6 addr show dev $interface | awk '/inet6 .* global/ {print $2}' | cut -d'/' -f1))

  echo -e "\e[92mCurrent IPv6 addresses on $interface:\e[0m"
  printf '%s\n' "${ipv6_addresses[@]}"

  read -e -p $'\e[93mAre these your current IPv6 addresses? (y/n): \e[0m' confirm

  if [[ $confirm != "y" && $confirm != "Y" ]]; then
      echo $'\e[91mAborted. Please manually configure the correct IPv6 addresses.\e[0m'
      exit 1
  fi


  IFS=$'\n' sorted_addresses=($(sort -r <<<"${ipv6_addresses[*]}"))
  unset IFS

  additional_address=""
  for ((i = 0; i < ${#sorted_addresses[@]}; i++)); do
      # current IPv6 address
      current_last_part=$(echo "${sorted_addresses[i]##*:}")


      modified_last_part_hex=$(printf '%04x' "$((16#$current_last_part + 1))")


      modified_address="${sorted_addresses[i]%:*}:$modified_last_part_hex"

      if [[ ! " ${sorted_addresses[@]} " =~ " $modified_address " ]]; then
          additional_address=$modified_address
          break
      fi
  done

  if [[ -z "$additional_address" ]]; then
      echo "No additional address to add."
      exit 0
  fi

  # interface
  ip addr add "$additional_address/64" dev $interface

  # /etc
  script_file="/etc/ipv6.sh"


  echo "ip addr add $additional_address/64 dev $interface" >> $script_file

  chmod +x $script_file

  # cronjob


  (crontab -l | grep -v "/etc/ipv6.sh") | crontab -


   display_notification $'\e[93mAdding cron job for the server...\e[0m'
  (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/ipv6.sh") | crontab -

  display_checkmark $'\e[92mIPv6 addresses added successfully!\e[0m'
}
function irann_rtt_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mRTT Iran + Native IPV6 Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
          		display_logoo
echo -e "\e[93m.----------------------------------------------------------------------------------------------------------------------.\e[0m"
echo -e "\e[93m| \e[92mEnter the number of native ipv6 address that you have on kharej server.you should enter them on iran server  \e[93m|\e[0m"
echo -e "\e[93m|\e[0m Tunnel port will be your new wireguard part. example : iPV4-iran: tunnel port                                       \e[0m"
echo -e "\e[93m|\e[36m Choose your desired SNI and enter a password. Terminate will be used for restarting service, choose it wisely         \e[0m"
echo -e "\e[93m'----------------------------------------------------------------------------------------------------------------------'\e[0m"
     display_notification $'\e[93mConfiguring Iran server...\e[0m'
	 printf "\e[93m╭────────────────────────────────────────────────────╮\e[0m\n"
# IPv6 iran
read -e -p $'\e[93mNumber of Kharej Native IPV6 addresses do you have ?: \e[0m' ipv6_count

read -e -p $'\e[93mEnter \e[92mTunnel port \e[93m(default: \e[92m443\e[93m) [This will be your new wireguard port]: \e[0m' lport
lport=${lport:-443}

read -e -p $'\e[93mEnter Tunnel \e[92mpassword \e[93m(default: azumi): \e[0m' password
password=${password:-azumi}

# sni
read -e -p $'\e[93mEnter your desired SNI (default: \e[92mgithub.com\e[93m): \e[0m' sni
sni=${sni:-github.com}

read -e -p $'\e[93mEnter \e[92mRestart \e[93mservice value (default: \e[92m24\e[93m): \e[0m' terminate
terminate=${terminate:-24}

# configuration
ipv6_config=""

for ((i=1; i<=ipv6_count; i++))
do
    read -e -p "$(printf '\033[92mEnter Kharej\033[93m IPV6 address %s: \033[0m' "$i")" ipv6_address
    ipv6_config+="--peer:$ipv6_address "
done
printf "\e[93m╰────────────────────────────────────────────────────╯\e[0m\n"
# service file
service_file="/etc/systemd/system/Radkesvatiran.service"

cat <<EOF > $service_file
[Unit]
Description=Reverse TLS Tunnel

[Service]
Type=idle
User=root
WorkingDirectory=/root
ExecStart=/root/./RTT --iran $ipv6_config--lport:$lport --accept-udp --connection-age:15 --keep-ufw --log:0 --password:$password --sni:$sni --terminate:$terminate
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start Radkesvatiran.service
sudo systemctl enable Radkesvatiran.service

# Add tunnel port to UFW if available
if [ -x "$(command -v ufw)" ]; then
    sudo ufw allow $lport
fi

display_checkmark $'\e[92mConfiguration and service updated successfully.\e[0m'
}
function kharejj_rtt_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mRTT Kharej + Native IPV6 Menu\e[0m'
      echo $'\e[92m "-"\e[93m════════════════════════════════\e[0m'
          		display_logoo
echo -e "\e[93m.-------------------------------------------------------------------------------------------------------------------------.\e[0m"
echo -e "\e[93m| \e[92mEnter your iran native ipv6 address, if you don't have one...please use RTT + privete ip menu                        \e[0m"
echo -e "\e[93m|\e[0m Tunnel port will be your new wireguard part. example : iPV4-iran: tunnel port                                    \e[0m"
echo -e "\e[93m| \e[92mKharej port is your current wireguard port                                                                     \e[0m"
echo -e "\e[93m|\e[36m Choose your desired SNI and enter a password. Terminate will be used for restarting service, choose it wisely            \e[93m|\e[0m"
echo -e "\e[93m'-------------------------------------------------------------------------------------------------------------------------'\e[0m"
      display_notification $'\e[93mConfiguring Kharej server...\e[0m'
	  printf "\e[93m╭────────────────────────────────────────────────────╮\e[0m\n"

read -e -p $'Enter \e[92mIran\e[93m Native IPv6 address: \e[0m' iranipv6

read -e -p $'Enter \e[92mTunnel\e[93m port (default: \e[92m443\e[93m): \e[0m' port
port=${port:-443}

read -e -p $'Enter \e[92mKharej\e[93m port \e[0m[your current wireguard port]: \e[0m' toport

read -e -p $'Enter \e[92mtunnel password\e[93m (default: \e[92mazumi\e[93m): \e[0m' password
password=${password:-azumi}

read -e -p $'\e[93mEnter your desired SNI (default: \e[92mgithub.com\e[93m): \e[0m' sni
sni=${sni:-github.com}
read -e -p $'\e[93mEnter \e[92mRestart \e[93mservice value (default: \e[92m24\e[93m): \e[0m' terminate
terminate=${terminate:-24}


printf "\e[93m╰────────────────────────────────────────────────────╯\e[0m\n"
# service file
service_file="/etc/systemd/system/Radkesvatkharej.service"

cat <<EOF > $service_file
[Unit]
Description=Reverse TLS Tunnel

[Service]
Type=idle
User=root
WorkingDirectory=/root
ExecStart=/root/./RTT --kharej --iran-ip:$iranipv6 --iran-port:$port --toip:127.0.0.1 --toport:$toport --password:$password --sni:$sni --terminate:$terminate
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start Radkesvatkharej.service
sudo systemctl enable Radkesvatkharej.service

# Add tunnel ports to UFW if available
if [ -x "$(command -v ufw)" ]; then
    sudo ufw allow $port
    sudo ufw allow $toport
fi
display_checkmark $'\e[92mConfiguration and service updated successfully.\e[0m'
}
function rtt-private() {
   clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mRTT + Private IP Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
		display_logoo
echo -e "\e[93m.-----------------------------------------------------------------------------------------------------------------.\e[0m"
echo -e "\e[93m| \e[92mFirst create your pivate ip on kharej and then on iran.  \e[0m"
echo -e "\e[93m|\e[0m After creating Private ip, please proceed establishing the tunnel first on iran server and then on kharej  \e[0m"
echo -e "\e[93m'-----------------------------------------------------------------------------------------------------------------'\e[0m"
  printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mPrivate IP\e[0m'
  echo $'2. \e[93mKharej RTT Tunnel\e[0m'
  echo $'3. \e[0mIRAN RTT Tunnel\e[0m'
  echo $'4. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'Enter your choice Please: ' server_type
    
case $server_type in
    1)
        priv_rtt_menu
        ;;
    2)
        kharej_rtt_menu
        ;;
    3)
        iran_rtt_menu
        ;;
    4)
        clear
        main_menu
        ;;
    *)
        echo "Invalid choice."
        ;;
esac
}
function iran_rtt_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mRTT Iran + Private ip Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      	display_logoo
echo -e "\e[93m.-----------------------------------------------------------------------------------------------------------------------------------------------------.\e[0m"
echo -e "\e[93m| \e[92mEnter the number of your kharej IPV6s, for loadbalance, you should enter youre kharej ipv6 on iran server \e[0m"
echo -e "\e[93m|\e[0m Tunnel port will be your new wireguard part. example : iPV4-iran: tunnel port                                        \e[0m"
echo -e "\e[93m|\e[36m Choose your desired SNI and enter a password. Terminate will be used for restarting service, choose it wisely     \e[0m"
echo -e "\e[93m'-----------------------------------------------------------------------------------------------------------------------------------------------------'\e[0m"
      display_notification $'\e[93mConfiguring Iran server...\e[0m'
	  printf "\e[93m╭────────────────────────────────────────────────────╮\e[0m\n"
# IPv6 iran
read -e -p $'Number of \e[92mKharej\e[93m IPV6 addresses do you have ?: \e[0m' ipv6_count

read -e -p $'\e[93mEnter \e[92mTunnel port \e[93m(default: \e[92m443\e[93m) [This will be your new wireguard port]: \e[0m' lport
lport=${lport:-443}

read -e -p $'Enter \e[92mtunnel password\e[93m (default: \e[92mazumi\e[93m): \e[0m' password
password=${password:-azumi}

# sni
read -e -p $'\e[93mEnter your desired SNI (default: \e[92mgithub.com\e[93m): \e[0m' sni
sni=${sni:-github.com}

read -e -p $'\e[93mEnter \e[92mRestart \e[93mservice value (default: \e[92m24\e[93m): \e[0m' terminate
terminate=${terminate:-24}

# configuration
ipv6_config=""

for ((i=1; i<=ipv6_count; i++))
do
    read -e -p "$(printf '\033[92mEnter Kharej\033[93m IPV6 address %s: \033[0m' "$i")" ipv6_address
    ipv6_config+="--peer:$ipv6_address "
done
printf "\e[93m╰────────────────────────────────────────────────────╯\e[0m\n"
# service file
service_file="/etc/systemd/system/Radkesvatiran.service"

cat <<EOF > $service_file
[Unit]
Description=Reverse TLS Tunnel

[Service]
Type=idle
User=root
WorkingDirectory=/root
ExecStart=/root/./RTT --iran $ipv6_config--lport:$lport --accept-udp --connection-age:15 --keep-ufw --log:0 --password:$password --sni:$sni --terminate:$terminate
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start Radkesvatiran.service
sudo systemctl enable Radkesvatiran.service

# Add tunnel port to UFW if available
if [ -x "$(command -v ufw)" ]; then
    sudo ufw allow $lport
fi

display_checkmark $'\e[92mConfiguration and service updated successfully.\e[0m'
}
function kharej_rtt_menu() {
   clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mRTT Kharej Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
               		display_logoo
echo -e "\e[93m.-------------------------------------------------------------------------------------------------------------------------.\e[0m"
echo -e "\e[93m| \e[92mEnter your iran private ipv6 address.                                                                         \e[0m"
echo -e "\e[93m|\e[0m Tunnel port will be your new wireguard port. example : iPV4-iran: tunnel port                                      \e[0m"
echo -e "\e[93m| \e[93mKharej port is your current wireguard port                                                                       \e[0m"
echo -e "\e[93m|\e[36m Choose your desired SNI and enter a password. Terminate will be used for restarting service, choose it wisely           \e[0m"
echo -e "\e[93m'-------------------------------------------------------------------------------------------------------------------------'\e[0m"
       display_notification $'\e[93mConfiguring Kharej server...\e[0m'
	   printf "\e[93m╭────────────────────────────────────────────────────╮\e[0m\n"
	   #!/bin/bash
read -e -p $'Enter \e[92mIran\e[93m private IPv6 address: \e[0m' iranipv6

read -e -p $'Enter \e[92mTunnel\e[93m port (default: \e[92m443\e[93m): \e[0m' port
port=${port:-443}

read -e -p $'Enter \e[92mKharej\e[93m port \e[0m[your current wireguard port]: \e[0m' toport

read -e -p $'Enter \e[92mtunnel password\e[93m (default: \e[92mazumi\e[93m): \e[0m' password
password=${password:-azumi}

read -e -p $'\e[93mEnter your desired SNI (default: \e[92mgithub.com\e[93m): \e[0m' sni
sni=${sni:-github.com}
read -e -p $'\e[93mEnter \e[92mRestart \e[93mservice value (default: \e[92m24\e[93m): \e[0m' terminate
terminate=${terminate:-24}


printf "\e[93m╰────────────────────────────────────────────────────╯\e[0m\n"
# service file
service_file="/etc/systemd/system/Radkesvatkharej.service"

cat <<EOF > $service_file
[Unit]
Description=Reverse TLS Tunnel

[Service]
Type=idle
User=root
WorkingDirectory=/root
ExecStart=/root/./RTT --kharej --iran-ip:$iranipv6 --iran-port:$port --toip:127.0.0.1 --toport:$toport --password:$password --sni:$sni --terminate:$terminate
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start Radkesvatkharej.service
sudo systemctl enable Radkesvatkharej.service

# Add tunnel ports to UFW if available
if [ -x "$(command -v ufw)" ]; then
    sudo ufw allow $port
    sudo ufw allow $toport
fi
display_checkmark $'\e[92mConfiguration and service updated successfully.\e[0m'
}
function priv_rtt_menu() {
   clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mPrivate IP Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
	display_logoo
echo -e "\e[93m.-------------------------------------------------------------------------------------------------------.\e[0m"
echo -e "\e[93m| \e[92mYou can use private ip and you can use it for tunnel instead of using native ipv6 \e[0m"
echo -e "\e[93m|\e[0m First create private ip on kharej and then iran                                                      \e[93m|\e[0m"
echo -e "\e[93m'-------------------------------------------------------------------------------------------------------'\e[0m"
  printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mKharej\e[0m'
  echo $'2. \e[91mIRAN\e[0m'
  echo $'3. \e[94mback to Previous menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'Enter your choice Please: ' server_type
  
case $server_type in
    1)
        kharej_private_menu
        ;;
    2)
        iran_private_menu
        ;;
    3)
        clear
        rtt-private
        ;;
    *)
        echo "Invalid choice."
        ;;
esac
}
function kharej_private_menu() {
      clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring kharej server\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
       display_logoo
      printf "\e[93m╭────────────────────────────────────────────────────────────────────────────────────────╮\e[0m\n"
        echo $'\e[92m   Please make sure to remove any private IPs that you have created before proceeding\e[0m'
      printf "\e[93m╰────────────────────────────────────────────────────────────────────────────────────────╯\e[0m\n"
	  display_notification $'\e[93mAdding private IP addresses for Kharej server...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address: \e[0m' remote_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::1/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"

# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done

    # private.sh
	display_notification $'\e[93mAdding commands to private.sh...\e[0m'
    echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
    echo "ip link set dev azumi up" >> /etc/private.sh
    echo "ip addr add fd1d:fc98:b73e:b481::1/64 dev azumi" >> /etc/private.sh
        ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1/64"
        echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh

    display_checkmark $'\e[92mPrivate ip added successfully!\e[0m'

display_notification $'\e[93mAdding cron job for server!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -
	
	ping -c 2 fd1d:fc98:b73e:b481::2 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
	display_notification $'\e[93mConfiguring keepalive service..\e[0m'

    # script
script_content='#!/bin/bash

# IPv6 address
ip_address="fd1d:fc98:b73e:b481::2"

# maximum number
max_pings=4

# Interval
interval=60

# Loop run
while true
do
    # Loop for pinging specified number of times
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
# private IP for Iran
function iran_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring Iran server\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
       display_logoo
      printf "\e[93m╭────────────────────────────────────────────────────────────────────────────────────────╮\e[0m\n"
        echo $'\e[92m   Please make sure to remove any private IPs that you have created before proceeding\e[0m'
      printf "\e[93m╰────────────────────────────────────────────────────────────────────────────────────────╯\e[0m\n"
    	  display_notification $'\e[93mAdding private IP addresses for Iran server...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address: \e[0m' remote_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address: \e[0m' local_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::2/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64" > /dev/null
  
  # Check iran
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done
# private.sh
    echo -e "\e[93mAdding commands to private.sh...\e[0m"
    echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
    echo "ip link set dev azumi up" >> /etc/private.sh
    echo "ip addr add fd1d:fc98:b73e:b481::2/64 dev azumi" >> /etc/private.sh
        ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64"
        echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh
    
    chmod +x /etc/private.sh

    display_checkmark $'\e[92mPrivate ip added successfully!\e[0m'


    display_notification $'\e[93mAdding cron job for server!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -

	ping -c 2 fd1d:fc98:b73e:b481::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
	display_notification $'\e[93mConfiguring keepalive service..\e[0m'

# script
script_content='#!/bin/bash

# iPv6 address
ip_address="fd1d:fc98:b73e:b481::1"


max_pings=3

# interval
interval=50

# loop run
while true
do
    # Loop for pinging specified number of times
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'

# display
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Iran):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
# Call
main_menu
