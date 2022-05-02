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
  Widget build(BuildContext context) {
    TextEditingController a = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
