import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'contact.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _db;

  DBHelper._();

  factory DBHelper() => _instance;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
    ''');
  }

  Future<int> insert(Contact contact) async {
    final dbClient = await db;
    return await dbClient.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('contacts');
    return maps.map((c) => Contact.fromMap(c)).toList();
  }

  Future<int> update(Contact contact) async {
    final dbClient = await db;
    return await dbClient.update('contacts', contact.toMap(),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<int> delete(int id) async {
    final dbClient = await db;
    return await dbClient.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
