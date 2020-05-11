-- DROP DATABASE secure-file-storage-metadata; Following is syntax error when you used different name of dbadmin as DATABASE name 
CREATE DATABASE IF NOT EXISTS secure-file-storage-metadata;
-- DROP TABLE files;
CREATE TABLE IF NOT EXISTS files (id UUID PRIMARY KEY, name TEXT, type TEXT, size DECIMAL, createdAt TIMESTAMPTZ DEFAULT current_timestamp, userId TEXT);
