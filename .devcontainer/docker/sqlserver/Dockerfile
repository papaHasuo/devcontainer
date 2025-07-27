# SQL Server開発環境用のDockerfile
FROM mcr.microsoft.com/mssql/server:2022-latest

# 環境変数の設定
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=YourStrong@Passw0rd
ENV MSSQL_PID=Developer

# 必要なツールをインストール
USER root
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# SQL Server用のディレクトリを作成
RUN mkdir -p /var/opt/mssql/data \
    && mkdir -p /var/opt/mssql/log \
    && mkdir -p /var/opt/mssql/backup

# 初期化スクリプト用のディレクトリを作成
RUN mkdir -p /docker-entrypoint-initdb.d

# データベースファイルの権限を設定
RUN chown -R mssql:root /var/opt/mssql/ \
    && chmod -R 755 /var/opt/mssql/

# ポート1433を公開
EXPOSE 1433
