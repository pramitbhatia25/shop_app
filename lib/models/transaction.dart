import 'product.dart';

class Transaction {
  int transaction_id;
  Product product_name;
  String inorout;

  Transaction({
    required this.transaction_id,
    required this.product_name,
    required this.inorout,
    String,
  });

  Map<String, dynamic> toMap(Transaction t) {
    return {
      'transaction_id': t.transaction_id,
      'product_id': t.product_name.product_id,
      'product_name': t.product_name.product_name,
      'product_date': t.product_name.product_date,
      'product_quantity': t.product_name.product_quantity,
      'product_price': t.product_name.product_price,
      'inorout': t.inorout
    };
  }
}
