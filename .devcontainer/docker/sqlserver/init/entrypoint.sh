#!/bin/bash

# SQL Serverをフォアグラウンドで実行
echo "Waiting for SQL Server to start..."
/opt/mssql/bin/sqlservr & MSSQL_PID=$!

# SQL Serverの起動を待機
while ! /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -Q "SELECT 1" > /dev/null 2>&1; do
    sleep 1
done
echo "SQL Server started."

# 初期化用SQLを実行
echo "Initializing database..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Passw0rd -i /docker-initdb.d/init.sql
echo "Database initialized."

# バックグラウンドで実行中のSQL Serverのプロセスを待機
wait $MSSQL_PID
