#-----------------------------------
#USER RIGHTS MANAGEMENT
#-----------------------------------
CREATE USER 'admincdb'@'172.18.0.3' IDENTIFIED WITH mysql_native_password BY 'qwerty1234';

GRANT ALL PRIVILEGES ON `computer-database-db`.* TO 'admincdb'@'172.18.0.3' WITH GRANT OPTION;


FLUSH PRIVILEGES;
