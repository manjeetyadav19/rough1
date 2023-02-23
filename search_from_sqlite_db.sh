#!/bin/sh

db="example.db"
table="copied_file"

echo "======Search Script====="
echo "Please Enter"
echo "Source File Name with location: e.g. /home/myadav/example.txt "
read fname

echo
echo "Below are the results:"
sqlite3 "$db" "Select * from $table where Sname like '$fname'";
echo

