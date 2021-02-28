-- the folde '/usr/local/var/db/apoyo' must exist in the filesystem
-- select spcname, pg_tablespace_location(oid) from pg_tablespace;
-- list table spaces : \db+
CREATE TABLESPACE apoyo OWNER admin  LOCATION '/usr/local/var/db/apoyo';
SET default_tablespace = apoyo;
