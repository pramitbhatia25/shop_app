import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../models/product.dart';

Future<sql.Database> getPDB() async {
  final database = sql.openDatabase(
    path.join(await sql.getDatabasesPath(), 'products.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE products(product_id INT PRIMARY KEY, product_name TEXT, product_date STRING, product_quantity INTEGER, product_price TEXT);',
      );
    },
    version: 1,
  );

  return database;
}

Future<void> insertProduct(Product product, sql.Database database) async {
  final db = database;

  await db.insert(
    'products',
    product.toMap(product),
    conflictAlgorithm: sql.ConflictAlgorithm.replace,
  );
}

Future<void> updateProduct(int id, String name, String date, String price,
    int quantity, sql.Database database) async {
  final db = database;
  await db.execute(
    'UPDATE products SET product_name = ?, product_date = ?, product_price = ?, product_quantity = ? where product_id = $id;',
    [name, date, price, quantity],
  );
  print("Updated!");
}

Future<void> deleteProduct(String name, sql.Database database) async {
  final db = database;
  await db.execute(
    'DELETE FROM products WHERE product_name = ?',
    [name],
  );
  print("Deleted!");
}

Future<List<Map<String, dynamic>>> fetchProductsFromDB(
    sql.Database database) async {
  final db = database;

  final List<Map<String, dynamic>> maps = await db.query('products');
  List<Map<String, dynamic>> ans = List.generate(maps.length, (i) {
    return {
      'product_id': maps[i]['product_id'],
      'product_name': maps[i]['product_name'],
      'product_date': maps[i]['product_date'],
      'product_quantity': maps[i]['product_quantity'],
      'product_price': maps[i]['product_price'],
    };
  });
  return ans;
}
