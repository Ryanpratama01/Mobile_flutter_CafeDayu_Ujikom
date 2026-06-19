import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cafe.dart';
import '../models/user.dart';
import '../models/ulasan.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'cafedayu.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel User
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT,
        fotoProfil TEXT
      )
    ''');

    // Tabel Cafe
    await db.execute('''
      CREATE TABLE cafes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        alamat TEXT,
        latitude REAL,
        longitude REAL,
        jamBuka TEXT,
        kisaranHarga TEXT,
        label TEXT,
        rating REAL,
        deskripsi TEXT,
        fotoUrl TEXT
      )
    ''');

    // Tabel Ulasan
    await db.execute('''
      CREATE TABLE ulasan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cafeId INTEGER,
        userId INTEGER,
        namaUser TEXT,
        rating REAL,
        komentar TEXT,
        tag TEXT,
        tanggal TEXT,
        FOREIGN KEY (cafeId) REFERENCES cafes (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // ============ USER ============
  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // ============ CAFE ============
  Future<int> insertCafe(Cafe cafe) async {
    final db = await database;
    return await db.insert('cafes', cafe.toMap());
  }

  Future<List<Cafe>> getAllCafes() async {
    final db = await database;
    final result = await db.query('cafes', orderBy: 'rating DESC');
    return result.map((map) => Cafe.fromMap(map)).toList();
  }

  Future<List<Cafe>> getTopCafes({int limit = 3}) async {
    final db = await database;
    final result = await db.query(
      'cafes',
      orderBy: 'rating DESC',
      limit: limit,
    );
    return result.map((map) => Cafe.fromMap(map)).toList();
  }

  Future<int> updateCafe(Cafe cafe) async {
    final db = await database;
    return await db.update(
      'cafes',
      cafe.toMap(),
      where: 'id = ?',
      whereArgs: [cafe.id],
    );
  }

  Future<int> deleteCafe(int id) async {
    final db = await database;
    return await db.delete('cafes', where: 'id = ?', whereArgs: [id]);
  }

  // ============ ULASAN ============
  Future<int> insertUlasan(Ulasan ulasan) async {
    final db = await database;
    return await db.insert('ulasan', ulasan.toMap());
  }

  Future<List<Ulasan>> getUlasanByCafe(int cafeId) async {
    final db = await database;
    final result = await db.query(
      'ulasan',
      where: 'cafeId = ?',
      whereArgs: [cafeId],
      orderBy: 'id DESC',
    );
    return result.map((map) => Ulasan.fromMap(map)).toList();
  }
}