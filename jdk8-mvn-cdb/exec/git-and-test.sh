#!/bin/bash
# Git repo
GIT_TARGET=computer-database

# File to modify
CONFIG_FILE=properties/db.properties

# Changes to be made
IP_ADDRESS=172.18.0.2
ADDRESS_PORT=3306

# If the $GIT_TARGET exists
if [ -d "$GIT_TARGET" ];
then
# Reset the modified file and pull
cd $GIT_TARGET \
    && git reset src/main/resources/$CONFIG_FILE
    && git pull
else
    # Clone the GIT_TARGET
    git clone https://github.com/alejeau/$GIT_TARGET.git
fi

# Change the file
sed -i 's/localhost:3306/'$IP_ADDRESS':'$ADDRESS_PORT'/g' $GIT_TARGET/src/main/resources/$CONFIG_FILE

# Run Maven
cd $GIT_TARGET \
	&& mvn clean \
	&& mvn test
