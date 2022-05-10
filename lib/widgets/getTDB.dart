import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../models/transaction.dart';

Future<sql.Database> getTDB() async {
  final database = sql.openDatabase(
    path.join(await sql.getDatabasesPath(), 'transactions.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE transactions(transaction_id INT PRIMARY KEY, product_id INT KEY, product_name TEXT, product_date STRING, product_quantity INTEGER, product_price TEXT, inorout TEXT);',
      );
    },
    version: 1,
  );
  return database;
}

Future<void> insertTransaction(
    Transaction transaction, sql.Database database) async {
  final db = await database;

  await db.insert(
    'transactions',
    transaction.toMap(transaction),
    conflictAlgorithm: sql.ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> fetchTransactionsFromDB(
    sql.Database database) async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query('transactions');
  List<Map<String, dynamic>> ans = List.generate(maps.length, (i) {
    return {
      'transaction_id': maps[i]['transaction_id'],
      'product_id': maps[i]['product_id'],
      'product_name': maps[i]['product_name'],
      'product_date': maps[i]['product_date'],
      'product_quantity': maps[i]['product_quantity'],
      'product_price': maps[i]['product_price'],
      'inorout': maps[i]['inorout'],
    };
  });
  return ans;
}
