import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {

  static Database? _db;
  static const int _version = 1;
  static const String _dbName = "e_new_app.db";

  static Future<Database> initDb() async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(path, version: _version, onCreate: _onCreate);
    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users(
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        profile_image TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Categories(
        category_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Articles(
        article_id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        image_url TEXT,
        category_id INTEGER,
        author_id INTEGER,
        published_at TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY(category_id) REFERENCES Categories(category_id),
        FOREIGN KEY(author_id) REFERENCES Users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Comments(
        comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        article_id INTEGER,
        user_id INTEGER,
        content TEXT,
        created_at TEXT,
        FOREIGN KEY(article_id) REFERENCES Articles(article_id),
        FOREIGN KEY(user_id) REFERENCES Users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Bookmarks(
        bookmark_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        article_id INTEGER,
        created_at TEXT,
        FOREIGN KEY(user_id) REFERENCES Users(user_id),
        FOREIGN KEY(article_id) REFERENCES Articles(article_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE History(
        history_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        article_id INTEGER,
        action_type TEXT,
        action_time TEXT,
        metadata TEXT,
        FOREIGN KEY(user_id) REFERENCES Users(user_id),
        FOREIGN KEY(article_id) REFERENCES Articles(article_id)
      )
    ''');

    await db.execute('''
        CREATE TABLE Likes(
          like_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          article_id INTEGER,
          created_at TEXT,
          FOREIGN KEY(user_id) REFERENCES Users(user_id),
          FOREIGN KEY(article_id) REFERENCES Articles(article_id)
        )
    ''');

    await db.execute('''
        CREATE TABLE Follows(
          follow_id INTEGER PRIMARY KEY AUTOINCREMENT,
          follower_id INTEGER,
          following_id INTEGER,
          created_at TEXT,
          FOREIGN KEY(follower_id) REFERENCES Users(user_id),
          FOREIGN KEY(following_id) REFERENCES Users(user_id)
        )
    ''');

  }
}