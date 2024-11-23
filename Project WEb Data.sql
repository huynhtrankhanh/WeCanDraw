USE wadlab7;FirstName
SELECT * FROM user;
-- ALTER TABLE user
-- ADD COLUMN FirstName VARCHAR(255) NOT NULL,
-- ADD COLUMN LastName VARCHAR(255) NOT NULL,
-- ADD COLUMN Email VARCHAR(255) NOT NULL UNIQUE;

-- CREATE DATABASE wadlab7;
-- USE wadlab7;

-- CREATE TABLE IF NOT EXISTS `user` (
-- `FirstName` varchar(255) NOT NULL,
-- `LastName` varchar(255) NOT NULL,
-- `Email` varchar(255) NOT NULL,
-- PRIMARY KEY (`FirstName`))



 CREATE DATABASE ProjectWeb;
 USE ProjectWeb;

 CREATE TABLE IF NOT EXISTS `user` (
`UserName` varchar(255) NOT NULL,
 `Email` varchar(255) NOT NULL,
 `Password` varchar(255) NOT NULL,
PRIMARY KEY (`Password`))
