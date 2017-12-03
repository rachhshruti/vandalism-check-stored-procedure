-- Table that stores the list of obscene words
create table badwords(words varchar(100));
	
-- Log table contains the list of all tables and their columns that contain obscene words
create table logtable(tblnm varchar(100), colnm varchar(100), phyloc2 varchar(100), curr_tms datetime );
