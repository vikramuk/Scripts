#!/usr/bin/perl
use DBI
use strict;
my $driver = "mysql"; 
my $database = "TESTDB";
my $dsn = "DBI:$driver:database=$database";
my $userid = "testuser";
my $password = "test123";
my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;

my $sth = $dbh->prepare("INSERT INTO TEST_TABLE
                       (FIRST_NAME, LAST_NAME, GENDER, AGE, INCOME )
                        values
                       ('john', 'poul', 'M', 30, 13000)");
$sth->execute() or die $DBI::errstr;
$sth->finish();
$dbh->commit or die $DBI::errstr;
