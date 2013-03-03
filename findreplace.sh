#!/bin/bash
# MySQL Database-wide Find/Replace - Case-sensitive Find/Replace for an entire MySQL database 
# https://github.com/kevin-jones/kj-mysql
# Inspired by http://www.krazyworks.com/mysql-global-search-and-replace/
# v0.1

# if your local machine uses "root" mysql username and an empty password, the following settings can be left as they are
MYSQL_USERNAME=root
MYSQL_PASSWORD=

echo -n "Enter database name: " ; read db_name
echo -n "Enter search string: " ; read search_string
echo -n "Enter replacement string: " ; read replacement_string

MYSQL="mysql --skip-column-names -u${MYSQL_USERNAME} --password=${MYSQL_PASSWORD}"

echo "SHOW TABLES;" | $MYSQL $db_name | while read db_table
do
	echo "SHOW COLUMNS FROM $db_table;" | $MYSQL $db_name| \
	awk -F'\t' '{print $1}' | while read tbl_column
	do
		echo "UPDATE $db_table SET ${tbl_column} = REPLACE(${tbl_column}, '${search_string}', '${replacement_string}');" |\
		$MYSQL $db_name
	done
done

