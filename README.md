# Create PostgresDB from StackExchange dump through Sqitch

This Sqitch bundle and TypeScript file allows you to move a StackExchange dump to a PostgresDB.

## Dependencies
* 7zip-min
* xml-js
* pg

## Usage
* Create a database where you will store the data.
* Download a stackexchange data dump from https://ia800107.us.archive.org/27/items/stackexchange/
* Compile and run DataRowsGenerator with the relative path and name of the downloaded .7z as an arg.
    * Ex. node StackDumpToDb.js korean.stackexchange.com.7z
* Replace dataRows.sql in the deploy folder with the dataRows.sql output from DataRowsGenerator.
    * The repository ships with with the korean.stackexchange.com dump as the default dataRows.sql. You can use this or replace it.
* Deploy the database with Sqitch.

## To do:
* Clean up code
* Error handling