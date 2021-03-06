import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/screens/product_description.dart';
import 'package:shop_app/screens/search_transaction.dart';
import '../models/transaction.dart';
import '../widgets/getTDB.dart';
import 'search_product.dart';

class transactions extends StatefulWidget {
  static const routeName = '/transactions';

  @override
  State<transactions> createState() => _transactionsState();
}

class _transactionsState extends State<transactions> {
  bool isLoading = true;
  List<Transaction> transactions = [];

  static const transactions_url =
      "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json";
  double height_of_container = 100;

  @override
  void initState() {
    fetch_transactions();
  }

  Future<void> fetch_transactions() async {
    // transactions = [];
    // final response = await http.get(Uri.parse(transactions_url));
    // var a = json.decode(response.body);
    // if (a == null) {
    //   Product temp = new Product(
    //       product_name: "No Product Added!",
    //       product_id: 0,
    //       product_date: DateTime.now().toString(),
    //       product_quantity: 0,
    //       product_price: "0");

    //   Transaction tempt =
    //       new Transaction(product_name: temp, inorout: "None        ");
    //   transactions.add(tempt);

    //   setState(() {
    //     height_of_container = 100;
    //     transactions = transactions.reversed.toList();
    //     isLoading = false;
    //   });
    // } else {
    //   a = json.decode(response.body) as Map<String, dynamic>;

    //   var i = 0;
    //   a.forEach((key, value) {
    //     transactions.add(Transaction(
    //         product_name: Product(
    //             product_id: 0,
    //             product_name: value['product_name']['product_name'],
    //             product_date:
    //                 DateTime.parse(value['product_name']['product_date'])
    //                     .toString(),
    //             product_price: value['product_name']['product_price'],
    //             product_quantity: int.parse(
    //                 value['product_name']['product_quantity'].toString())),
    //         inorout: value['inorout']));
    //     i++;
    //   });

    //   setState(() {
    //     height_of_container = i * 100;
    //     transactions = transactions.reversed.toList();
    //     isLoading = false;
    //   });
    // }

    transactions = [];

    final database = getTDB();

    List<Map<String, dynamic>> transactionsInDB =
        await fetchTransactionsFromDB(await database);

    if (transactionsInDB.length == 0) {
      Product temp = new Product(
          product_id: 0,
          product_name: "No Product Added!",
          product_date: DateTime.now().toString(),
          product_quantity: 0,
          product_price: "0");
      Transaction tempT = new Transaction(
          transaction_id: 0, product_name: temp, inorout: "None        ");
      transactions = [];
      transactions.add(tempT);
      print("No item db = {$transactions}");
      setState(() {
        height_of_container = 100;
        transactions = transactions.reversed.toList();
        isLoading = false;
      });
    } else {
      var i = transactionsInDB.length;
      transactions = [];
      for (int j = 0; j < i; j++) {
        print("t = " + transactionsInDB[j].toString());
        Product newP = Product(
            product_id: transactionsInDB[j]['product_id'],
            product_name: transactionsInDB[j]['product_name'].toString(),
            product_date: transactionsInDB[j]['product_date'],
            product_price: transactionsInDB[j]['product_price'],
            product_quantity: transactionsInDB[j]['product_quantity']);
        Transaction newT = Transaction(
            transaction_id: j + 1,
            product_name: newP,
            inorout: transactionsInDB[j]['inorout']);

        transactions.add(newT);
      }
      print("Transactions from db = {$transactions}");

      setState(() {
        height_of_container = i * 100;
        transactions = transactions.reversed.toList();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(search_transaction.routeName)
                    .then((_) {
                  setState(() {
                    fetch_transactions();
                  });
                });
              },
              iconSize: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60),
              child: Text(
                'Transactions',
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
      height: height_of_container + 80,
      // decoration: BoxDecoration(
      //   border: Border.all(width: 1, color: Colors.brown),
      // ),
      child: !isLoading
          ? ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: transactions.map((pd) {
                String in_or_out = pd.inorout.substring(0, 4) != "Same"
                    ? pd.inorout.substring(0, 8)
                    : "None    ";
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
                                  "${in_or_out == "None    " ? "" : in_or_out == "Outgoing" ? '-' : '+'}${in_or_out == "None    " ? "" : pd.inorout.substring(9, pd.inorout.length)}",
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
