rm -rf computer-database

git clone https://github.com/alejeau/computer-database.git

rm -rf src/main/resources/properties/db.properties

cp db.properties src/main/resources/properties/db.properties

cd computer-database \
	&& mvn clean \
	&& mvn test
