import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabel untuk Register & Login Pengguna[cite: 46]
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Tabel untuk Menyimpan Data Transaksi Keuangan[cite: 46]
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        title TEXT,
        amount TEXT,
        type TEXT,
        category TEXT,
        date TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN type TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE transactions ADD COLUMN user_id INTEGER');
    }
  }

  // --- Operasi User ---
  Future<int> registerUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // --- Operasi Transaksi ---
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    print('[DB] Inserting transaction: $row');
    final result = await db.insert('transactions', row);
    print('[DB] Transaction inserted with ID: $result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getTransactions(int userId) async {
    final db = await instance.database;
    return await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
  }

  Future<double> getTotalBalance(int userId) async {
    final income = await getTotalIncome(userId);
    final expense = await getTotalExpense(userId);
    return income - expense;
  }

  Future<double> getTotalIncome(int userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COALESCE(SUM(CAST(amount AS REAL)), 0) as total FROM transactions WHERE type = "Pemasukan" AND user_id = ?',
      [userId],
    );
    final total = results.first['total'];
    print('[DB] Total Pemasukan (user $userId): $total');
    return (total is int) ? total.toDouble() : (total as double? ?? 0.0);
  }

  Future<double> getTotalExpense(int userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COALESCE(SUM(CAST(amount AS REAL)), 0) as total FROM transactions WHERE type = "Pengeluaran" AND user_id = ?',
      [userId],
    );
    final total = results.first['total'];
    print('[DB] Total Pengeluaran (user $userId): $total');
    return (total is int) ? total.toDouble() : (total as double? ?? 0.0);
  }
}