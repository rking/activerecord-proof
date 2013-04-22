-- This is a lazy way to do a "migration", just do like:
--   sqlite3 db/test.sqlite3 < db/migrations/load.sql
CREATE TABLE "authors" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "hometown" varchar(255), "year_born" date);
CREATE TABLE "books" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "author_id" integer, "title" varchar(255), "year_published" integer);
