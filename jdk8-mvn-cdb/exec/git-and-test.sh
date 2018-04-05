#!/bin/bash
# Git repo
GIT_TARGET=computer-database

# File to modify
CONFIG_FILE=properties/db.properties

# Changes to be made
IP_ADDRESS=172.18.0.2
ADDRESS_PORT=3306

# Remove the old GIT_TARGET
rm -rf $GIT_TARGET

# Get the GIT_TARGET
git clone https://github.com/alejeau/$GIT_TARGET.git

# Change the file
sed -i 's/localhost:3306/'$IP_ADDRESS':'$ADDRESS_PORT'/g' $GIT_TARGET/src/main/resources/$CONFIG_FILE

# Run Maven
cd computer-database \
	&& mvn clean \
	&& mvn test
