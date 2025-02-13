#!/bin/bash

# Function to create a user account
create_user() {
    read -p "Enter the new username: " username
 
    # Check if user already exists
    if id "$username" &>/dev/null; then
      echo "Error: User '$username' already exists."
      exit 1
    fi
    
    read -s -p "Enter the password: " password
    echo
    
    # Create the user and set the password
    sudo useradd -m "$username"
    echo "$username:$password" | sudo chpasswd
    
    echo "Success: User '$username' has been created."
}

# Function to check if user does not exist.
check_user(){
	if ! id "$username" &>/dev/null; then
		echo "Error: User '$username' does not exist."
		exit 1
	fi
}


# Function to delete a user account

delete_user() {

	read -p "Enter the user to delete: " username

	# Checck if the user exists
	check_user

	# Delete the user

	sudo userdel -r "$username"

	echo "Success: User '$username' has been deleted."
}

# Function to reset the user's password

reset_pass(){
	read -p "Enter the user name to reset password: " username
	check_user
	read -s  -p "Enter new password: " password
	echo

	# Reset the password

	echo "$username:$password" | sudo chpasswd

	echo "Success: Password for '$username' has been reset."

}

# Function to list all user accounts
list_users() {
       echo "Listing all user accounts:"
       cut -d: -f1,3 /etc/passwd | column -t -s: 
}

# Check for command-line arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 -c | --create | -d | --delete | -r | --reset | -l | --list"
    exit 1
fi

# Function to display help and usage information
show_help() {
    echo "Usage: $0 [OPTION]"
    echo "Options:"
    echo "  -c, --create    Create a new user account"
    echo "  -d, --delete    Delete an existing user account"
    echo "  -r, --reset     Reset the password of an existing user account"
    echo "  -l, --list      List all user accounts with their UIDs"
    echo "  -h, --help      Display this help and usage information"
}

# Parse command-line arguments
case "$1" in
    -c|--create)
        create_user
        ;;
	-d|--delete)
	delete_user
	;;
-r|--reset)
	reset_pass
	;;
-l|--list)
	list_users
	;;
-h|--help)
	show_help
	;;
    *)
        echo "Invalid option. Use -h or --help for usage information."
        exit 1
        ;;
esac

