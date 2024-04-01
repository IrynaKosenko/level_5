#!/bin/bash

echo "The script starts"

rootuser=$1
ip=$2
username=$3
key=$4
pathfromroottoubuntu="/home/iryna/Desktop/MyFiles/key_pair.pem"
pathfromroottonewuser="/home/iryna/Desktop/MyFiles/userScript_key_pair.pem"
#pathfromusertoubuntu="~/Desktop/MyFiles/key_pair.pem"
#pathfromusertonewuser="~/Desktop/MyFiles/userScript_key_pair.pem"

ssh -i "$pathfromroottoubuntu" -T $rootuser@$ip <<-EOF

if id "$username" >/dev/null 2>&1; then
	echo "User '$username' already exist"
else
	sudo adduser $username
    	sudo passwd -d $username
	echo "User '$username' has been created with password '$password'"
	sudo usermod -aG sudo $username
	echo "Sudo rights has been added"

	sudo su - $username <<-NESTED_EOF
		mkdir .ssh
		chmod 700  .ssh
		
		if [ -f .ssh/authorized_keys ]; then
			echo "File 'authorized_keys' already exist"
		else
			touch .ssh/authorized_keys
			chmod 600 .ssh/authorized_keys
			echo "$key" >> .ssh/authorized_keys
			echo "New file 'authorized_keys' has been created"
		fi

		if grep -qF "$key" .ssh/authorized_keys; then
			echo "Public key already in file 'authorized_keys'"
		else
			echo "$key" >> .ssh/authorized_keys
			echo "Public key has been added to the file 'authorized_keys'"
		fi

	NESTED_EOF
fi
EOF

echo "Connecting to the server with new user"
ssh -i "$pathfromroottonewuser" $username@$ip
