#!/bin/bash

source /etc/os-release

IFACE=$(ip route show default | awk '{print $5}')
IP=$(ip -4 addr show $IFACE | grep inet | awk '{print $2}' | cut -d'/' -f1)

CONFIG="/etc/samba/smb.conf"

LOG_FILE="/tmp/samba_install_$(date +%Y%m%d_%H%M%S).log"

if [ "$EUID" -ne 0 ]; then
  error_message "Please run as root or with sudo"
  exit 1
fi

# installing samba
echo "Installing samba packge..."
case "$ID" in
ubuntu | debain)
  apt-get update -y >>"$LOG_FILE" 2>&1
  apt-get install -y samba samba-common-bin smbclient >>"$LOG_FILE" 2>&1
  ;;
centos | almalinux | rocky | rhel | fedora)
  dnf install -y epel-release >>"$LOG_FILE" 2>&1
  dnf install -y samba samba-client samba-common >>"$LOG_FILE" 2>&1
  ;;
opensuse*)
  zypper up -y >>"$LOG_FILE" 2>&1
  zypper in -y samba samba-client >>"$LOG_FILE" 2>&1
  ;;
arch)
  pacman -Sy --noconfirm samba smbclient >>"$LOG_FILE" 2>&1
  ;;
*)
  echo "Unsupport OS: $ID"
  exit 1
  ;;
esac

if [[ $? -eq 0 ]]; then
  echo "Samba successfully installed"
else
  echo "Failed to installed samba"
fi

shared_user() {
  read -p "Which user want to use in samba config for public user? " USER
  if getent passwd $USER >/dev/null 2>&1; then
    echo "$USER is exist"
  else
    echo "$USER is not exists"
    echo "so adding a new user for samba "

    read -p "Enter password: " -s password

    # Adding user
    useradd -m -p "$password" "$USER"
    echo "the user added"
  fi
}

configure_samba() {
  read -p "Enter share name" SHARE_NAME
  read -p "Which path/directory want to shared ?" dir
  mkdir -p "$dir"

  chown -R $USER:$USER $dir

  cat >>"$CONFIG" <<EOF

  [$SHARE_NAME]
   path = "$dir"
   browsable = yes
   writable = yes
   valid users = $USER
   force user = $USER
   create mask = 0755
   directory mask = 0755
   read only =  no
EOF

  # setting up user for samba
  echo -e "$password\n$password" | smbpasswd -a -s "$USER"
  smbpasswd -e $USER

  if systemctl enable --now smb nmb || systemctl enable --now smbd nmbd; then
    #echo "Samba has been installed and configured "
    cat <<EOF

    Samba share created successfully 🎉

    Mount command:
    mount -t cifs //$IP/$SHARE_NAME YOUR_MOUNT_POINT  -o credentials=/root/.cifs-credentials,vers=3.1.1,sec=ntlmssp,file_mode=0777,dir_mode=0777,nobrl

EOF
  else
    echo "Failed configured"
    exit 1
  fi
}

shared_user
configure_samba
