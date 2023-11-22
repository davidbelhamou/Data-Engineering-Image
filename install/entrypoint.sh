#!/bin/bash
# Assign the first argument passed to the script to the variable 'INITIALS'.
# This value is intended to be used for generating a unique SSH port.
INITIALS=$1

# Reverse the 'INITIALS', format it to ensure it's a three-digit number (padding with zeros if needed),
# and then reverse it back. This ensures 'INITIALS' is always three digits.
# Example: If 'INITIALS' is '12', it becomes '210'. If it's '5', it becomes '500'.
INITIALS=$(printf '%03d' $(echo $INITIALS | rev) | rev)

# Construct the SSH port number by appending '22' to the three-digit 'INITIALS'.
# This creates a unique SSH port number based on the input.
# Example: If 'INITIALS' is '500', 'SSH_PORT' becomes '50022'.
SSH_PORT="${INITIALS}22"
JUPYTER_PORT="${INITIALS}88"

# Set the root password for the SSH connection.
ROOT_PASSWORD="12345678"
echo "SSH Port: $SSH_PORT"
echo "Jupyter Port: $JUPYTER_PORT"

# Add the custom SSH port to the SSH configuration file.
echo "Port $SSH_PORT" >> /etc/ssh/sshd_config
export JUPYTER_PORT=$JUPYTER_PORT

# Set Hadoop CLASSPATH
CLASSPATH=$(/usr/local/hadoop/bin/hadoop classpath --glob)

# Set the root password as specified.
echo "root:$ROOT_PASSWORD" | chpasswd

# Start the SSH service.
service ssh start

# Start Jupyter Lab in the background.
jupyter-lab &

# Start a bash shell to keep the container running.
bash