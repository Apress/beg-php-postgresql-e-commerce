CREATE USER     hatshopadmin
       PASSWORD 'hatshopadmin'
       SUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE
       VALID UNTIL 'infinity';

CREATE DATABASE hatshop WITH OWNER = hatshopadmin
                        ENCODING = 'UTF8';
