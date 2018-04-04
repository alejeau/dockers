rm -rf computer-database

git clone https://github.com/alejeau/computer-database.git

rm -rf computer-database/src/main/resources/properties/db.properties

cp /home/db.properties computer-database/src/main/resources/properties/db.properties

cd computer-database \
	&& mvn clean \
	&& mvn test
