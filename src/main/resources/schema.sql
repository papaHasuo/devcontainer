-- Users テーブルの作成（SQL Server用）
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
BEGIN
    CREATE TABLE users (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        email NVARCHAR(255) NOT NULL UNIQUE,
        created_at DATETIME2(7) DEFAULT GETDATE(),
        updated_at DATETIME2(7) DEFAULT GETDATE()
    );
END

-- サンプルデータの挿入
IF NOT EXISTS (SELECT * FROM users)
BEGIN
    INSERT INTO users (name, email) VALUES 
    (N'山田太郎', 'yamada@example.com'),
    (N'佐藤花子', 'sato@example.com'),
    (N'田中次郎', 'tanaka@example.com');
END
