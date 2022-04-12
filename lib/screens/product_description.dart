import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../models/transaction.dart';
import 'search_product.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class product_description extends StatefulWidget {
  static const routeName = '/product_description';

  product_description({required this.pd});
  final Product pd;

  @override
  State<product_description> createState() => _product_descriptionState();
}

TextEditingController _dateController = TextEditingController();
TextEditingController _dateController2 = TextEditingController();

bool isIn(String a, String b) {
  return b.contains(a);
}

class _product_descriptionState extends State<product_description> {
  bool isLoading = true;
  List<Product> products = [];
  List<Transaction> transactions = [];
  List<Transaction> searched_transactions = [];

  static const url =
      "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
  static const transactions_url =
      "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json";
  double height_of_container = 100;

  @override
  void initState() {
    get_transactions();
  }

  Future<void> get_transactions() async {
    await fetch_transactions();
    if (transactions.length == 1 &&
        transactions[0].product_name == "No Transactions!") {
      print("A");
      searched_transactions.add(transactions[0]);
    } else {
      for (int i = 0; i < transactions.length; i++) {
        if (widget.pd.product_name ==
            transactions[i].product_name.product_name) {
          searched_transactions.add(transactions[i]);
        }
      }
    }

    setState(() {
      searched_transactions = searched_transactions;
      height_of_container = (searched_transactions.length) * 100;
    });
  }

  Future<void> fetch() async {
    products = [];
    final response = await http.get(Uri.parse(url));
    var a = json.decode(response.body);
    if (a == null) {
      Product temp = new Product(
          product_name: "No Product Added!",
          product_id: "temp",
          product_date: DateTime.now(),
          product_quantity: 0,
          product_price: "0");

      products.add(temp);
      setState(() {
        height_of_container = 100;
        products = products.reversed.toList();
        isLoading = false;
      });
    } else {
      var i = 0;
      a.forEach((key, value) {
        products.add(Product(
            product_id: key,
            product_name: value['product_name'],
            product_date: DateTime.parse(value['product_date']),
            product_price: value['product_price'],
            product_quantity: value['product_quantity']));
        i++;
      });

      setState(() {
        height_of_container = i * 100;
        products = products.reversed.toList();
        isLoading = false;
      });
    }
  }

  Future<void> fetch_transactions() async {
    transactions = [];
    final response = await http.get(Uri.parse(transactions_url));
    var a = json.decode(response.body);
    if (a == null) {
      Product temp = new Product(
          product_name: "No Product Added!",
          product_id: "temp",
          product_date: DateTime.now(),
          product_quantity: 0,
          product_price: "0");

      Transaction tempt =
          new Transaction(product_name: temp, inorout: "None        ");
      transactions.add(tempt);

      setState(() {
        height_of_container = 100;
        transactions = transactions.reversed.toList();
        isLoading = false;
      });
    } else {
      a = json.decode(response.body) as Map<String, dynamic>;

      var i = 0;
      a.forEach((key, value) {
        transactions.add(Transaction(
            product_name: Product(
                product_id: key,
                product_name: value['product_name']['product_name'],
                product_date:
                    DateTime.parse(value['product_name']['product_date']),
                product_price: value['product_name']['product_price'],
                product_quantity: int.parse(
                    value['product_name']['product_quantity'].toString())),
            inorout: value['inorout']));
        i++;
      });

      setState(() {
        height_of_container = i * 100;
        transactions = transactions.reversed.toList();
        isLoading = false;
      });
      print(transactions);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController a = TextEditingController();
    return Scaffold(
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
              SizedBox(height: 20),
              products_and_icons(),
              SizedBox(height: 20),
              product_detail(),
              product_widget()
            ],
          ),
        ),
      ),
    );
  }

  Widget product_detail() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Text("Product Name: ",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
                Text("Product Price: ",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
                Text("Product Date: ",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
                Text("Product Quantity: ",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Text(widget.pd.product_name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
                Text(widget.pd.product_price,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
                Text(widget.pd.product_date.toString().substring(0, 10),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
                Text(widget.pd.product_quantity.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
      ]),
    );
  }

  Widget products_and_icons() {
    TextEditingController one = TextEditingController();
    TextEditingController three = TextEditingController();
    TextEditingController four = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              widget.pd.product_name,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1)),
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
      child: !isLoading
          ? ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: searched_transactions.map((pd) {
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
                              Text("${pd.product_name.product_quantity}",
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
