#!/bin/bash
set -e

echo "Starting SQL Server custom entrypoint..."

# SQL Serverをバックグラウンドで開始
echo "Starting SQL Server in background..."
/opt/mssql/bin/sqlservr &
SQLSERVER_PID=$!

# SQL Serverが起動するまで待機
echo "Waiting for SQL Server to start..."
for i in {1..60}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1" > /dev/null 2>&1; then
        echo "SQL Server is ready!"
        break
    fi
    echo "Waiting for SQL Server... ($i/60)"
    sleep 2
done

# 初期化スクリプトを実行
if [ -d "/docker-entrypoint-initdb.d" ]; then
    echo "Running initialization scripts..."
    for script in /docker-entrypoint-initdb.d/*.sh; do
        if [ -f "$script" ]; then
            echo "Executing $script"
            chmod +x "$script"
            "$script"
        fi
    done
    
    for script in /docker-entrypoint-initdb.d/*.sql; do
        if [ -f "$script" ]; then
            echo "Executing $script"
            /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -i "$script"
        fi
    done
fi

echo "Initialization completed. SQL Server is running."

# フォアグラウンドでSQL Serverを継続実行
wait $SQLSERVER_PID
