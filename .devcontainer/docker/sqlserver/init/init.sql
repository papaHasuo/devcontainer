-- データベース初期化スクリプト
USE devdb;

-- usersテーブルを作成
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        email NVARCHAR(255) UNIQUE NOT NULL,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2 DEFAULT GETDATE()
    );
    
    PRINT 'Table users created successfully.';
END
ELSE
BEGIN
    PRINT 'Table users already exists.';
END

-- サンプルデータの挿入
IF NOT EXISTS (SELECT * FROM users)
BEGIN
    INSERT INTO users (name, email) VALUES 
        (N'田中太郎', 'tanaka@example.com'),
        (N'佐藤花子', 'sato@example.com'),
        (N'鈴木次郎', 'suzuki@example.com');
    
    PRINT 'Sample data inserted successfully.';
END
ELSE
BEGIN
    PRINT 'Sample data already exists.';
END

-- 初期化完了メッセージ
PRINT 'Database initialization completed successfully!';
