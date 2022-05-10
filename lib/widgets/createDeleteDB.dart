import 'getPDB.dart';
import 'getTDB.dart';

Future<void> createTable(String pOrT) async {
  if (pOrT == 'P') {
    final database = getPDB();
    (await database).execute(
      'CREATE TABLE products(product_id INT PRIMARY KEY, product_name TEXT, product_date STRING, product_quantity INTEGER, product_price TEXT);',
    );
  } else {
    final database = getTDB();
    (await database).execute(
      'CREATE TABLE transactions(transaction_id INT PRIMARY KEY, product_id INT KEY, product_name TEXT, product_date STRING, product_quantity INTEGER, product_price TEXT, inorout TEXT);',
    );
  }
  print("Created Table");
}

Future<void> droppedTable(String tablename) async {
  if (tablename == 'products') {
    final database = getPDB();
    (await database).execute(
      'DROP TABLE IF EXISTS $tablename;',
    );
  } else {
    final database = getTDB();
    (await database).execute(
      'DROP TABLE IF EXISTS $tablename;',
    );
  }
  print("Dropped Table");
}
