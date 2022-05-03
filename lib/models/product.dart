class Product {
  String product_name;
  String product_date;
  int product_quantity;
  String product_price;
  int product_id;

  Product({
    required this.product_name,
    required this.product_id,
    required this.product_date,
    required this.product_quantity,
    required this.product_price,
  });

  Map<String, dynamic> toMap(Product p) {
    return {
      'product_id': p.product_id,
      'product_name': p.product_name,
      'product_date': p.product_date,
      'product_quantity': p.product_quantity,
      'product_price': p.product_price,
    };
  }
}
