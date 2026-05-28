import 'package:boutique_app/models/cart_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabase {
  // Singleton
  static final CartDatabase instance = CartDatabase._internal();

  CartDatabase._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'cart.db');

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        productId INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  // Lire tous les articles
  Future<List<CartItemModel>> getAll() async {
    final db = await database;

    final rows = await db.query('cart_items');

    return rows.map((e) => CartItemModel.fromMap(e)).toList();
  }

  // Ajouter ou incrémenter
  Future<void> addOrIncrement(CartItemModel item) async {
    final db = await database;

    final existing = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [item.productId],
    );

    if (existing.isNotEmpty) {
      final current = CartItemModel.fromMap(existing.first);

      await db.update(
        'cart_items',
        {'quantity': current.quantity + item.quantity},
        where: 'productId = ?',
        whereArgs: [item.productId],
      );
    } else {
      await db.insert('cart_items', item.toMap());
    }
  }

  // Modifier quantité
  Future<void> updateQuantity(int productId, int quantity) async {
    final db = await database;

    if (quantity <= 0) {
      await delete(productId);
    } else {
      await db.update(
        'cart_items',
        {'quantity': quantity},
        where: 'productId = ?',
        whereArgs: [productId],
      );
    }
  }

  // Supprimer un article
  Future<void> delete(int productId) async {
    final db = await database;

    await db.delete(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  // Vider le panier
  Future<void> clearAll() async {
    final db = await database;

    await db.delete('cart_items');
  }

  Future<void> close() async {
    final db = await database;

    db.close();
  }
}
