# SQL Server開発環境 設定ガイド

## 概要
このSQL Server環境は、Spring Boot Javaアプリケーションとの統合開発用に設定されています。

## 自動実行される初期化処理

Dev Container起動時に以下のスクリプトが**自動実行**されます：

1. **01-create-database.sql** - データベースとテーブルの作成
2. **99-check-status.sql** - 初期化状況の確認

### 初期化内容
- ✅ データベース: `devdb`
- ✅ テーブル: `users` (id, name, email, created_at)
- ✅ サンプルデータ: 3件のユーザーレコード
- ✅ ストアドプロシージャ: `GetUserCount`

## データベース接続情報
- **ホスト**: `sqlserver` (コンテナ内から) / `localhost` (ホストから)
- **ポート**: `1433`
- **データベース名**: `devdb`
- **ユーザー名**: `sa`
- **パスワード**: `YourStrong@Passw0rd`

## 手動での初期化確認

もし初期化がうまくいかない場合は、以下のコマンドで手動確認できます：

```bash
# コンテナ内でSQL実行
docker exec devcontainer_devcontainer-sqlserver-1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /docker-entrypoint-initdb.d/99-check-status.sql -C

# コンテナのログ確認
docker logs devcontainer_devcontainer-sqlserver-1
```

## Java (Spring Boot) での接続設定

### build.gradleに依存関係を追加
```gradle
dependencies {
    // SQL Server JDBC ドライバー
    implementation 'com.microsoft.sqlserver:mssql-jdbc:12.4.2.jre11'
    
    // Spring Boot JPA
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
}
```

### application.propertiesの設定
```properties
# データベース接続設定
spring.datasource.url=jdbc:sqlserver://sqlserver:1433;databaseName=devdb;encrypt=false;trustServerCertificate=true
spring.datasource.username=sa
spring.datasource.password=YourStrong@Passw0rd
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

# JPA設定
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.SQLServerDialect
```

## 接続テスト用のJavaコード

### エンティティクラス
```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String email;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // getter/setter...
}
```

### リポジトリ
```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
}
```

### コントローラー
```java
@RestController
@RequestMapping("/api")
public class UserController {
    
    @Autowired
    private UserRepository userRepository;
    
    @GetMapping("/users")
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    @GetMapping("/db-test")
    public String testConnection() {
        try {
            long count = userRepository.count();
            return "Database connection successful! User count: " + count;
        } catch (Exception e) {
            return "Database connection failed: " + e.getMessage();
        }
    }
}
```

## SQL Server Management Studio (SSMS) での接続
- **サーバー名**: `localhost,1433`
- **認証**: SQL Server認証
- **ログイン**: `sa`
- **パスワード**: `YourStrong@Passw0rd`

## トラブルシューティング

### 接続できない場合
1. コンテナが起動しているか確認: `docker ps`
2. ログを確認: `docker logs <sqlserver-container-name>`
3. ネットワーク設定を確認: `docker network ls`

### データが見つからない場合
1. 初期化スクリプトが実行されたか確認
2. ボリュームの状態を確認: `docker volume ls`
