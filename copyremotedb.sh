#!/bin/sh
# MySQL Database Copy - Replace local database with remote version 
# by kevin.jones@tecmark.co.uk
# https://github.com/kevin-jones/kj-mysql
# v0.3

# This script is most useful when developing a website on your local machine.
# Running the script will replace a local MySQL database with one from a remote server.
# This is handy to keep your local MySQL database in sync with the remote one.
# It is good practise to make all DB changes on the remote server, then use this script to synchronise.
# This ensures then remote database is always up to date and no schema changes are missed.

# WARNING: the script will entirely replace your local database with the remote one! Backup first if necessary!

# Before Using...
# 1. Check you can run the "mysql" command from the command line
# 2. If you can't ensure mysql is in your PATH (e.g. PATH=${PATH}:/usr/local/mysql/bin)
# 3. Check you can SSH to the remote MySQL DB server and run mysql commands
# 4. Give the script executable permissions (e.g. chmod +x copyremotedb.sh)
# 5. Amend the configuration below for default settings

# Config

DEFAULT_REMOTE_SERVER=
DEFAULT_REMOTE_MYSQL_USERNAME=
DEFAULT_SSH_USERNAME=

# if your local machine uses "root" mysql username and an empty password, the following settings can be left as they are
LOCAL_MYSQL_USERNAME=root
LOCAL_MYSQL_PASSWORD=
LOCAL_MYSQL_HOST=localhost

# The Script

echo "Remote DB Server [$DEFAULT_REMOTE_SERVER]"
read server
: ${server:="$DEFAULT_REMOTE_SERVER"}

echo  "SSH User [$DEFAULT_SSH_USERNAME]"
read user
: ${user:="$DEFAULT_SSH_USERNAME"}

echo "Remote MySQL User [$DEFAULT_SSH_USERNAME]"
read remote_mysql_username
: ${remote_mysql_username:="$DEFAULT_SSH_USERNAME"}

echo "-----------------------"

echo "Remote MySQL Password"
read remote_mysql_password

echo "Remote MySQL Database"
read remote_database_name

# default to using the same local DB name as the remote one
echo "Local MySQL Database [$remote_database_name]"
read local_database_name
: ${local_database_name:="$remote_database_name"}

# Run The Command (uses SSH & MYSQL)

ssh $user@$server "mysqldump -u $remote_mysql_username --password=$remote_mysql_password $remote_database_name" | mysql -u $LOCAL_MYSQL_USERNAME --password=$LOCAL_MYSQL_PASSWORD --host=$LOCAL_MYSQL_HOST -C $local_database_name
