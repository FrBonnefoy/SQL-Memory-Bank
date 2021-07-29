--- MYSQL commands


-- 1.) List all tables in database

SET @database = 'name of db';
select * from information_schema.tables
where table_schema = @database
order by table_name, ordinal_position


-- 2.) List all columns of database across tables

SET @database = 'name of db';
select * from information_schema.columns
where table_schema = @database
order by table_name, ordinal_position

-- 3.) List all columns of database across a specific table

SET @database = 'name of db', @table='name of table';
select * from information_schema.columns
where table_schema = @database AND table_name=@table
order by table_name, ordinal_position
