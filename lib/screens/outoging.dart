import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../models/transaction.dart';
import 'search_product.dart';

class outgoing extends StatefulWidget {
  static const routeName = '/outgoing';

  @override
  State<outgoing> createState() => _outgoingState();
}

class _outgoingState extends State<outgoing> {
  bool isLoading = true;
  List<Transaction> outgoing_transactions = [];

  static const transactions_url =
      "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json";
  double height_of_container = 100;

  @override
  void initState() {
    fetch_outgoing_transactions();
  }

  Future<void> fetch_outgoing_transactions() async {
    outgoing_transactions = [];
    final response = await http.get(Uri.parse(transactions_url));
    var a = json.decode(response.body);

    if (a == null) {
      Product temp = new Product(
          product_name: "No Product Added!",
          product_id: 0,
          product_date: DateTime.now().toString(),
          product_quantity: 0,
          product_price: "0");

      Transaction tempt =
          new Transaction(product_name: temp, inorout: "None        ");
      outgoing_transactions.add(tempt);

      setState(() {
        height_of_container = 100;
        outgoing_transactions = outgoing_transactions.reversed.toList();
        isLoading = false;
      });
    } else {
      var i = 0;
      a.forEach((key, value) {
        if (value['inorout'].toString().substring(0, 4) != "Same") {
          if (value['inorout'].toString().substring(0, 8) == "Outgoing") {
            outgoing_transactions.add(Transaction(
                product_name: Product(
                    product_id: 0,
                    product_name: value['product_name']['product_name'],
                    product_date:
                        DateTime.parse(value['product_name']['product_date'])
                            .toString(),
                    product_price: value['product_name']['product_price'],
                    product_quantity: int.parse(
                        value['product_name']['product_quantity'].toString())),
                inorout: value['inorout']));
            i++;
          }
          ;
        }
      });

      setState(() {
        height_of_container = i * 100;
        outgoing_transactions = outgoing_transactions.reversed.toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController a = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Evening',
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    wordSpacing: 2,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -1.5))),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
              products_and_icons(),
              SizedBox(height: 20),
              product_widget(),
              // delete_all_products(),
            ],
          ),
        ),
      ),
    );
  }

  Widget good_eve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text('Good Evening!',
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      wordSpacing: 2,
                      fontWeight: FontWeight.normal,
                      letterSpacing: -1.5))),
        ),
      ),
    );
  }

  Widget products_and_icons() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60),
              child: Text(
                'Outgoing',
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget product_widget() {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      height: height_of_container < 100 ? 700 : height_of_container + 80,
      // decoration: BoxDecoration(
      //   border: Border.all(width: 1, color: Colors.brown),
      // ),
      child: !isLoading
          ? ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: outgoing_transactions.map((pd) {
                String in_or_out = pd.inorout.substring(0, 8);
                return Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width - 40,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: in_or_out == "Outgoing"
                        ? Colors.red.withOpacity(0.3)
                        : in_or_out != "None    "
                            ? Colors.green.withOpacity(0.3)
                            : Colors.transparent,
                    border: Border.all(
                        color: in_or_out == "Outgoing"
                            ? Colors.red
                            : in_or_out != "None    "
                                ? Colors.green
                                : Colors.white,
                        width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 40.0,
                            right: 40,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("${pd.product_name.product_name}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5)),
                              Text(
                                  "${in_or_out == "Outgoing" ? '-' : in_or_out != "None    " ? '+' : ''}${pd.inorout.substring(9, pd.inorout.length)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          : Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()))),
    );
  }
}
