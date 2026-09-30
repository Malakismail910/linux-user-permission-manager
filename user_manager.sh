#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run this script as root."
    exit 1
fi



create_user() {
    read -p "Enter username: " username

    if id "$username" &>/dev/null; then
        echo "User already exists"
        return
    fi

    useradd -m "$username"

    if [ $? -eq 0 ]; then
        echo "User created successfully."
    else
        echo "Failed to create user."
    fi
}


delete_user() {
    read -p "Enter username: " username

    if ! id "$username" &>/dev/null; then
        echo "User does not exist."
        return
    fi

    read -p "Are you sure you want to delete $username? (y/n): " confirm

    if [ "$confirm" = "y" ]; then
        userdel -r "$username"
        echo "User deleted."
    else
        echo "Operation cancelled."
    fi
}


create_group() {
    read -p "Enter group name: " group

    if getent group "$group" &>/dev/null; then
        echo "Group already exists"
        return
    fi

    groupadd "$group"

    if [ $? -eq 0 ]; then
        echo "Group successfully created"
    else
        echo "Failed to create group"
    fi
}


add_user_to_group() {
    read -p "Enter username: " username
    read -p "Enter group: " group

    if ! id "$username" &>/dev/null; then
        echo "User does not exist."
        return
    fi

    if ! getent group "$group" &>/dev/null; then
        echo "Group does not exist"
        return
    fi

    usermod -aG "$group" "$username"

    echo "User added to group."
}


lock_user() {
    read -p "Enter username: " username

    if ! id "$username" &>/dev/null; then
        echo "User does not exist"
        return
    fi

    passwd -l "$username"
    echo "User account locked"
}


unlock_user() {
    read -p "Enter username: " username

    if ! id "$username" &>/dev/null; then
        echo "User does not exist"
        return
    fi

    passwd -u "$username"
    echo "User account unlocked"
}


show_user_info() {
    read -p "Enter username: " username

    if ! id "$username" &>/dev/null; then
        echo "User does not exist"
        return
    fi

    echo "==============================="
    echo "User Information"
    echo "==============================="

    id "$username"

    echo
    echo "Groups:"
    groups "$username"

    echo
    echo "Home Directory:"
    getent passwd "$username" | cut -d: -f6
}


change_permissions() {
    read -p "Enter file/directory path: " path
    read -p "Enter permissions (e.g. 640): " permissions

    if [ ! -e "$path" ]; then
        echo "Path does not exist."
        return
    fi

    chmod "$permissions" "$path"

    echo "Permissions updated."

    ls -ld "$path"
}


change_owner() {
    read -p "Enter file/directory path: " path
    read -p "Enter new owner: " owner

    if [ ! -e "$path" ]; then
        echo "Path does not exist."
        return
    fi

    if ! id "$owner" &>/dev/null; then
        echo "User does not exist."
        return
    fi

    chown "$owner" "$path"

    echo "Owner changed."

    ls -ld "$path"
}


remove_user_from_group() {
    read -p "Enter username: " username
    read -p "Enter groupname: " group

    if ! id "$username" &>/dev/null; then
        echo "User does not exist"
        return
    fi

    if ! getent group "$group" &>/dev/null; then
        echo "Group does not exist"
        return
    fi

    gpasswd -d "$username" "$group"

    if [ $? -eq 0 ]; then
        echo "User removed from group successfully."
    else
        echo "Failed to remove user from group."
    fi
}


change_password() {
    read -p "Enter username: " username

    if ! id "$username" &>/dev/null; then
        echo "User does not exist"
        return
    fi

    passwd "$username"

    if [ $? -eq 0 ]; then
        echo "Password changed successfully."
    else
        echo "Failed to change password."
    fi
}
security_audit() {

    echo "===================================="
    echo "        Linux Security Audit"
    echo "===================================="

    echo
    echo "[+] Users with UID 0:"
    awk -F: '$3 == 0 {print $1}' /etc/passwd

    echo
    echo "[+] Users with login shells:"
    awk -F: '$7 ~ /(bash|sh|zsh)$/ {print $1 ":" $7}' /etc/passwd

    echo
    echo "[+] Current logged-in users:"
    who

    echo
    echo "[+] Last logins:"
    last -n 5

    echo
    echo "[+] World-writable files in /tmp:"
    find /tmp -type f -perm -0002 2>/dev/null

    echo
    echo "===================================="
}

while true; do

    echo
    echo "===================================="
    echo " Linux User & Permission Manager"
    echo "===================================="

    echo "1. Create User"
    echo "2. Delete User"
    echo "3. Create Group"
    echo "4. Add User to Group"
    echo "5. Remove User from Group"
    echo "6. Lock User"
    echo "7. Unlock User"
    echo "8. Change Password"
    echo "9. Change File Permissions"
    echo "10. Change File Owner"
    echo "11. Show User Information"
    echo "12. Security Audit"
    echo "13. Exit"

    read -p "Choose an option: " choice

    case $choice in
        1)
            create_user
            ;;
        2)
            delete_user
            ;;
        3)
            create_group
            ;;
        4)
            add_user_to_group
            ;;
        5)
            remove_user_from_group
            ;;
        6)
            lock_user
            ;;
        7)
            unlock_user
            ;;
        8)
            change_password
            ;;
        9)
            change_permissions
            ;;
        10)
            change_owner
            ;;
        11)
            show_user_info
            ;;
        12)
            security_audit
            ;;
        13)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac

done
