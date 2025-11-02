// lib/db/pembantu_db.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/resep.dart';

class PembantuDB {
  static final PembantuDB instan = PembantuDB._init();
  static Database? _database;
  PembantuDB._init();

  static const String tabelResep = 'resep';
  static const String tabelPengguna = 'pengguna';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inisialisasiDB('aplikasi_resep.db');
    return _database!;
  }

  Future<Database> _inisialisasiDB(String namaFile) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, namaFile);
    return await openDatabase(path, version: 1, onCreate: _buatDB);
  }

  Future _buatDB(Database db, int versi) async {
    await db.execute('''
    CREATE TABLE $tabelResep (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      judul TEXT NOT NULL,
      deskripsi TEXT NOT NULL,
      bahan TEXT NOT NULL,
      langkah TEXT NOT NULL,
      dibuatPada TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE $tabelPengguna (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT,
      email TEXT UNIQUE,
      sandi TEXT
    )
    ''');
  }

  // ===== CRUD Resep =====
  Future<Resep> buatResep(Resep resep) async {
    final db = await instan.database;
    final id = await db.insert(tabelResep, resep.keMap());
    return resep.salinDengan(id: id);
  }

  Future<List<Resep>> bacaSemuaResep() async {
    final db = await instan.database;
    final hasil = await db.query(tabelResep, orderBy: 'id DESC');
    return hasil.map((m) => Resep.dariMap(m)).toList();
  }

  Future<Resep?> bacaResep(int id) async {
    final db = await instan.database;
    final maps = await db.query(tabelResep, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Resep.dariMap(maps.first);
    return null;
  }

  Future<int> ubahResep(Resep resep) async {
    final db = await instan.database;
    return db.update(tabelResep, resep.keMap(), where: 'id = ?', whereArgs: [resep.id]);
  }

  Future<int> hapusResep(int id) async {
    final db = await instan.database;
    return db.delete(tabelResep, where: 'id = ?', whereArgs: [id]);
  }

  // ===== Pengguna (sederhana, lokal) =====
  Future<int> buatPengguna(String nama, String email, String sandi) async {
    final db = await instan.database;
    return db.insert(tabelPengguna, {'nama': nama, 'email': email, 'sandi': sandi});
  }

  Future<Map<String, dynamic>?> dapatkanPenggunaDenganEmail(String email) async {
    final db = await instan.database;
    final maps = await db.query(tabelPengguna, where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  Future close() async {
    final db = await instan.database;
    db.close();
  }
}
