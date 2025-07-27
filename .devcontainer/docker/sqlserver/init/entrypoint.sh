#!/bin/bash
set -e

echo "Starting SQL Server initialization script..."

# SQL Serverをフォアグラウンドで実行
echo "Starting SQL Server in background..."
/opt/mssql/bin/sqlservr & 
MSSQL_PID=$!

# SQL Serverの起動を待機（最大60秒）
echo "Waiting for SQL Server to be ready..."
for i in {1..60}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1" > /dev/null 2>&1; then
        echo "SQL Server is ready!"
        break
    fi
    echo "Waiting for SQL Server... ($i/60)"
    sleep 1
done

# データベースの初期化
echo "Initializing database..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'devdb')
BEGIN
    CREATE DATABASE devdb;
    PRINT 'Database devdb created successfully.';
END
ELSE
BEGIN
    PRINT 'Database devdb already exists.';
END
"

# 初期化SQLファイルがあれば実行
if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
    echo "Executing init.sql..."
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -d devdb -i /docker-entrypoint-initdb.d/init.sql
fi

echo "Database initialization completed."

# バックグラウンドで実行中のSQL Serverのプロセスを待機
wait $MSSQL_PID
