# Automation tool for checking vandalism on websites

Created a stored procedure in SQL server to check for vandalism on websites.
It takes the name of the table that contains a list of obscene words as input parameter, it checks the character fields of all the tables in a database to see if it contains any of the obscene words and it returns the tablename, columname, physical location and timestamp as the result table which is then logged in a log table. Based on the log table, the tables can then be cleaned by using delete query.

# Running the SQL script:

1. __tables.sql:__  creates the needed tables for the stored procedure.
2. __VandalismCheckStoredProc.sql:__ creates the stored procedure, executes it and the results can be viewed.