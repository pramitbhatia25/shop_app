import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/screens/incoming.dart';
import 'package:shop_app/screens/outoging.dart';
import 'package:shop_app/screens/product_description.dart';
import 'package:shop_app/screens/search_product.dart';
import 'package:shop_app/screens/search_transaction.dart';
import 'package:shop_app/screens/welcome.dart';
import 'models/product.dart';
import 'screens/products.dart';
import 'screens/transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: welcome(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Lato',
      ),
      routes: {
        transactions.routeName: (ctx) => transactions(),
        welcome.routeName: (ctx) => welcome(),
        products_home.routeName: (ctx) => products_home(),
        incoming.routeName: (ctx) => incoming(),
        outgoing.routeName: (ctx) => outgoing(),
        search_product.routeName: (ctx) => search_product(),
        product_description.routeName: (ctx) => product_description(
            pd: Product(
                product_date: DateTime.now().toString(),
                product_id: 0,
                product_name: "",
                product_price: "",
                product_quantity: 12)),
        search_transaction.routeName: (ctx) => search_transaction(),
      },
    );
  }
}
