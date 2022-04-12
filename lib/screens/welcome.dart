import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/models/transaction.dart';
import 'package:shop_app/screens/incoming.dart';
import 'package:shop_app/screens/products.dart';
import 'package:shop_app/screens/transactions.dart';
import 'search_product.dart';
import 'package:shop_app/screens/outoging.dart';

class welcome extends StatefulWidget {
  static const routeName = '/welcome';

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  @override
  void initState() {
    // FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController a = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: myAppBar(title: "Home"),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.purple,
              Colors.black,
              Colors.black,
              Colors.black,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: Lottie.asset('lib/assets/lottie/welcomePage.json',
                        height: 200.0),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(products_home.routeName);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 10, bottom: 10),
                      child: Text('Products',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -1.5))),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(incoming.routeName);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 10, bottom: 10),
                      child: Text('Incoming',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -1.5))),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(outgoing.routeName);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 10, bottom: 10),
                      child: Text('Outgoing',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -1.5))),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Pushing temporary product in names
                      // await http.post(
                      //     Uri.parse(
                      //         "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names.json"),
                      //     body: json.encode({
                      //       'product_name': "No Product Added!",
                      //       'product_detail': "",
                      //       'product_price': 0,
                      //       'product_quantity': 0
                      //     }));
                      // Product temp = new Product(
                      //     product_name: "No Transactions yet!",
                      //     product_id: "temp",
                      //     product_detail: "",
                      //     product_quantity: 0,
                      //     product_price: 0);

                      // Pushing temporary transaction in transactions
                      // Transaction tempt =
                      //     new Transaction(product_name: temp, inorout: "None");

                      // await http.post(
                      //     Uri.parse(
                      //         "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json"),
                      //     body: json.encode({
                      //       'product_name': {
                      //         'product_name': tempt.product_name.product_name,
                      //         'product_id': tempt.product_name.product_id,
                      //         'product_detail':
                      //             tempt.product_name.product_detail,
                      //         'product_quantity':
                      //             tempt.product_name.product_quantity,
                      //         'product_price': tempt.product_name.product_price,
                      //       },
                      //       'inorout': tempt.inorout
                      //     }));
                      Navigator.of(context).pushNamed(transactions.routeName);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 10, bottom: 10),
                      child: Text('Transactions',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -1.5))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
