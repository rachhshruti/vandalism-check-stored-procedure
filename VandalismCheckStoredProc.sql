/* The vandalism stored procedure is used to check for obscene words in the character fields of all the tables 
in the selected database. It takes the name of the table that contains a list of obscene words as input 
parameter and it returns the tablename, columname, physical location and timestamp as the result table which 
is then logged in a log table.
@author Shruti Rachh, Prerna Preeti
*/
alter Proc vandalism @badtable varchar(200) 
AS
declare @DD table (tblnm varchar(100),colnm varchar(100));
insert into @DD select TABLE_NAME,COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE like '%varchar%' and table_name not like @badtable order by 1,2;

DECLARE @tbl varchar(100)
DECLARE @col varchar(100)
DECLARE @phy varchar(100)
DECLARE @tblret1 varchar(100)
DECLARE @colret1 varchar(100)
DECLARE @phyloc1 varchar(100)
declare @fnltbl table( tblnm varchar(100), colnm varchar(100), phyloc2 varchar(100), curr_tms datetime )

DECLARE cur CURSOR FOR SELECT tblnm, colnm FROM @DD
OPEN cur

FETCH NEXT FROM cur INTO @tbl, @col

WHILE @@FETCH_STATUS = 0 BEGIN
	declare @sqlcmd varchar(500)
	declare @cnt table ( ct varchar(100))
	set @sqlcmd='Select sys.fn_PhysLocFormatter(%%physloc%%) From '+@tbl+' where '+@col+' in (select * from '+@Badtable+');'
	delete from @cnt;
	insert into @cnt(ct)
	exec(@sqlcmd)
	if (exists(select 1 from @cnt)) 
	begin
		DECLARE cur1 CURSOR FOR SELECT ct FROM @cnt
		OPEN cur1

		FETCH NEXT FROM cur1 INTO @phy
		WHILE @@FETCH_STATUS = 0 BEGIN
		insert into @fnltbl values( @tbl,@col,@phy,GETDATE());

		FETCH NEXT FROM cur1 INTO @phy
		END
		CLOSE cur1   
		DEALLOCATE cur1
	end
    FETCH NEXT FROM cur INTO @tbl, @col
END

select * from @fnltbl group by tblnm,colnm,phyloc2,curr_tms;

insert into logtable select * from @fnltbl fnl
		where not exists(
		select * from logtable where
		logtable.tblnm=fnl.tblnm
		and logtable.colnm=fnl.colnm
		and logtable.phyloc2=fnl.phyloc2)


CLOSE cur    
DEALLOCATE cur
GO

-- Execute the stored procedure
exec vandalism badwords;

-- View the results
select * from logtable;

-- Clean up of the tables based on the physical location (physloc) stored in the log table
delete from tablename where sys.fn_PhysLocFormatter(%%physloc%%)='physical location'; 