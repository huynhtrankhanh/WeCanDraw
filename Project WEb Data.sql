



 CREATE DATABASE ProjectWeb;
 USE ProjectWeb;

 CREATE TABLE IF NOT EXISTS `user` (
`UserName` varchar(255) NOT NULL,
 `Email` varchar(255) NOT NULL,
 `Password` varchar(255) NOT NULL,
PRIMARY KEY (`Password`))



USE ProjectWeb;
CREATE TABLE meetings (
    meetingID VARCHAR(255) PRIMARY KEY,  --  Unique ID (e.g., alphanumeric)
    creationTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP );