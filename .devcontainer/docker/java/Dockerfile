# Java開発環境用のDockerfile
FROM mcr.microsoft.com/devcontainers/java:1-21-bullseye

# 必要なツールとライブラリをインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# vscodeユーザーのGradleディレクトリを作成し、権限を設定
RUN mkdir -p /home/vscode/.gradle && \
    chown -R vscode:vscode /home/vscode/.gradle && \
    chmod -R 755 /home/vscode/.gradle

# Javaのバージョンを確認
RUN java -version

# 作業ディレクトリを設定
WORKDIR /workspace

# Javaのフィーチャー設定を適用
# （ベースイメージに既に含まれているため、追加設定は不要）

# ポート8080を公開
EXPOSE 8080

# デフォルトユーザーをvscodeに設定
USER vscode