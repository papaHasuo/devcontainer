-- データベースの作成
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'devdb')
BEGIN
    CREATE DATABASE devdb;
    PRINT 'Database devdb created successfully!';
END
ELSE
BEGIN
    PRINT 'Database devdb already exists.';
END
GO

USE devdb;
GO

-- サンプルテーブルの作成
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
BEGIN
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        email NVARCHAR(255) UNIQUE NOT NULL,
        created_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table users created successfully!';
END
ELSE
BEGIN
    PRINT 'Table users already exists.';
END
GO

-- サンプルデータの挿入
IF NOT EXISTS (SELECT * FROM users)
BEGIN
    INSERT INTO users (name, email) VALUES 
    ('Alice Johnson', 'alice@example.com'),
    ('Bob Smith', 'bob@example.com'),
    ('Charlie Brown', 'charlie@example.com');
    PRINT 'Sample data inserted successfully!';
END
ELSE
BEGIN
    PRINT 'Sample data already exists.';
END
GO
