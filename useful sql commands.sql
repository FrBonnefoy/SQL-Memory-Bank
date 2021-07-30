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

-- 4.) Find where a specific column is

SET @database = 'mavenmovies';
set @columnsearch = 'replacement_cost';
SELECT
    *
FROM
    information_schema.columns
WHERE
    table_schema = @database
        AND column_name = @columnsearch
ORDER BY table_name , ordinal_position;

-- 5.) Create wordcount function

DELIMITER $$
CREATE FUNCTION wordcount(str LONGTEXT)
       RETURNS INT
       DETERMINISTIC
       SQL SECURITY INVOKER
       NO SQL
  BEGIN
    DECLARE wordCnt, idx, maxIdx INT DEFAULT 0;
    DECLARE currChar, prevChar BOOL DEFAULT 0;
    SET maxIdx=char_length(str);
    SET idx = 1;
    WHILE idx <= maxIdx DO
        SET currChar=SUBSTRING(str, idx, 1) RLIKE '[[:alnum:]]';
        IF NOT prevChar AND currChar THEN
            SET wordCnt=wordCnt+1;
        END IF;
        SET prevChar=currChar;
        SET idx=idx+1;
    END WHILE;
    RETURN wordCnt;
  END
$$
DELIMITER ;
