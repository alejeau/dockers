#!/bin/bash
# Git repo
GIT_TARGET=computer-database
TARGET_BRANCH=master
TARGET_VERSION=production
TARGET_ACTION=install

# File to modify
CONFIG_FILE=src/main/resources/properties/db.properties

# Changes to be made
IP_ADDRESS=172.18.0.2
ADDRESS_PORT=3306

# Parse the arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--target)
        TARGET_VERSION="$2"
        shift # past argument
        shift # past value
        ;;
    *)
        echo $"Usage: $0 {target}"
        echo "No target specified, will default to production."
        ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ $TARGET_VERSION = "test" ];
then
    TARGET_BRANCH=dev
    TARGET_ACTION=test
fi


# If the $GIT_TARGET exists
if [ -d "$GIT_TARGET" ];
then
# Reset the modified file and pull
cd $GIT_TARGET \
    && git checkout $TARGET_BRANCH \
    && git reset $CONFIG_FILE \
    && git pull origin $TARGET_BRANCH
else
    # Clone the GIT_TARGET
    git clone https://github.com/alejeau/$GIT_TARGET.git
    cd $GIT_TARGET \
    && git checkout $TARGET_BRANCH
fi

# Change the file
sed -i 's/localhost:3306/'$IP_ADDRESS':'$ADDRESS_PORT'/g' $CONFIG_FILE

# Run Maven
mvn clean && mvn $TARGET_ACTION

if [ $TARGET_VERSION = "production" ];
then
    mv $(ls target/*.war) target/$GIT_TARGET.war
fi

