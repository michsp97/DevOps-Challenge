create schema challenge;
use challenge;

CREATE TABLE IF NOT EXISTS pet
(
name varchar(20),
owner varchar(20),
species varchar(20),
sex char(1)
);

INSERT INTO pet (name, owner, species, sex) VALUES ('secondAdmin', 'password', 'true', 'm');
INSERT INTO pet (name, owner, species, sex) VALUES ('cat', 'ilse', 'mammal', 'f');
SELECT * FROM pet;