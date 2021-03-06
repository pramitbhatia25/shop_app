import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/screens/product_description.dart';
import 'package:shop_app/widgets/getTDB.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../models/transaction.dart';
import '../widgets/createDeleteDB.dart';
import '../widgets/getPDB.dart';
import 'search_product.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class products_home extends StatefulWidget {
  static const routeName = '/products_home';

  @override
  State<products_home> createState() => _products_homeState();
}

TextEditingController _dateController = TextEditingController();
TextEditingController _dateController2 = TextEditingController();

class _products_homeState extends State<products_home> {
  bool isLoading = true;
  List<Product> products = [];
  List<Transaction> transactions = [];
  late sql.Database Pdb;
  late sql.Database Tdb;

  static const url =
      "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
  static const transactions_url =
      "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json";
  double height_of_container = 100;

  @override
  void initState() {
    // droppedTable('products');
    // droppedTable('transactions');
    // createTable('P');
    // createTable('T');
    fetch();
  }

  Future<void> fetch() async {
    // products = [];
    // final response = await http.get(Uri.parse(url));
    // var a = json.decode(response.body);
    // if (a == null) {
    //   Product temp = new Product(
    //       product_name: "No Product Added!",
    //       product_id: "temp",
    //       product_date: DateTime.now(),
    //       product_quantity: 0,
    //       product_price: "0");

    //   products.add(temp);
    //   setState(() {
    //     height_of_container = 100;
    //     products = products.reversed.toList();
    //     isLoading = false;
    //   });
    // } else {
    //   var i = 0;
    //   a.forEach((key, value) {
    //     products.add(Product(
    //         product_id: key,
    //         product_name: value['product_name'],
    //         product_date: DateTime.parse(value['product_date']),
    //         product_price: value['product_price'],
    //         product_quantity: value['product_quantity']));
    //     i++;
    //   });

    //   setState(() {
    //     height_of_container = i * 100;
    //     products = products.reversed.toList();
    //     isLoading = false;
    //   });
    // }
    Pdb = await getPDB();
    Tdb = await getTDB();

    List<Map<String, dynamic>> productsInDB = await fetchProductsFromDB(Pdb);

    print(productsInDB.length);
    products = [];

    if (productsInDB.length == 0) {
      Product temp = new Product(
          product_id: 0,
          product_name: "No Product Added!",
          product_date: DateTime.now().toString(),
          product_quantity: 0,
          product_price: "0");

      products.add(temp);

      print("No item db = {$products}");

      setState(() {
        height_of_container = 100;
        products = products.reversed.toList();
        isLoading = false;
      });
    } else {
      var i = productsInDB.length;
      for (int j = 0; j < i; j++) {
        Product newP = Product(
            product_id: productsInDB[j]['product_id'],
            product_name: productsInDB[j]['product_name'],
            product_date: productsInDB[j]['product_date'],
            product_price: productsInDB[j]['product_price'],
            product_quantity: productsInDB[j]['product_quantity']);
        products.add(newP);
      }

      print("Products from db = {$products}");

      setState(() {
        height_of_container = i * 100;
        products = products.reversed.toList();
        isLoading = false;
      });
    }
  }

  Future<void> fetch_transactions() async {
    // transactions = [];
    // final response = await http.get(Uri.parse(transactions_url));
    // var a = json.decode(response.body);
    // if (a == null) {
    //   Product temp = new Product(
    //       product_name: "No Product Added!",
    //       product_id: 0,
    //       product_date: DateTime.now(),
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
    //             product_id: key,
    //             product_name: value['product_name']['product_name'],
    //             product_date:
    //                 DateTime.parse(value['product_name']['product_date']),
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
    // print("Actual transactions= {$transactions}");

    transactions = [];

    List<Map<String, dynamic>> transactionsInDB =
        await fetchTransactionsFromDB(Tdb);

    if (transactionsInDB.length == 0) {
      Product temp = new Product(
          product_id: 0,
          product_name: "No Product Added!",
          product_date: DateTime.now().toString(),
          product_quantity: 0,
          product_price: "0");
      Transaction tempT = new Transaction(
          transaction_id: 0, product_name: temp, inorout: "None        ");
      transactions.add(tempT);
      print("No item db = {$transactions}");
      setState(() {
        transactions = transactions.reversed.toList();
        isLoading = false;
      });
    } else {
      var i = transactionsInDB.length;
      for (int j = 0; j < i; j++) {
        Product newP = Product(
            product_id: transactionsInDB[j]['product_id'],
            product_name: transactionsInDB[j]['product_name'],
            product_date: transactionsInDB[j]['product_date'],
            product_price: transactionsInDB[j]['product_price'],
            product_quantity: transactionsInDB[j]['product_quantity']);

        Transaction newT = Transaction(
            transaction_id: transactions.length,
            product_name: newP,
            inorout: transactionsInDB[j]['inorout']);

        transactions.add(newT);
      }
      print("Transactions from db = {$transactions}");

      setState(() {
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
          child: Text('Good Evening...',
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
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(search_product.routeName)
                    .then((_) {
                  setState(() {
                    fetch();
                  });
                });
              },
              iconSize: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60),
              child: Text(
                'Products',
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1)),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              iconSize: 30,
              onPressed: () {
                _dateController.text =
                    DateTime.now().toString().substring(0, 10);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            content: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Positioned(
                                  right: -40,
                                  top: -40,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      child: Icon(
                                        Icons.close,
                                      ),
                                      backgroundColor: Colors.purple,
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.2,
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            TextFormField(
                                              controller: one,
                                              decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: Colors.purple
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  hintText:
                                                      "Enter Product Name"),
                                              style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              validator: (value) {
                                                var names = [];
                                                for (int i = 0;
                                                    i < products.length;
                                                    i++) {
                                                  names.add(
                                                      products[i].product_name);
                                                }

                                                if (value == null ||
                                                    value.isEmpty ||
                                                    names.contains(one.text)) {
                                                  return 'Please Enter Valid Product Name';
                                                }
                                                return null;
                                              },
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: BasicDateField(),
                                            ),
                                            TextFormField(
                                              controller: three,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: Colors.purple
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  hintText:
                                                      "Enter Product Quantity"),
                                              style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    int.tryParse(value) ==
                                                        null ||
                                                    int.tryParse(value)! < 1) {
                                                  return 'Please Enter Valid Product Quantity';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller: four,
                                              decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: Colors.purple
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  hintText:
                                                      "Enter Product Price"),
                                              style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Product Price';
                                                }
                                                return null;
                                              },
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.purple),
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    bool productsIsEmpty = products[
                                                                    0]
                                                                .product_name ==
                                                            "No Product Added!"
                                                        ? true
                                                        : false;

                                                    Product postP = new Product(
                                                        product_name: one.text,
                                                        product_id:
                                                            productsIsEmpty
                                                                ? 1
                                                                : products
                                                                        .length +
                                                                    1,
                                                        product_date:
                                                            _dateController
                                                                .text,
                                                        product_quantity:
                                                            int.parse(
                                                                three.text),
                                                        product_price:
                                                            four.text);

                                                    List<Map<String, dynamic>>
                                                        productsInDB =
                                                        await fetchProductsFromDB(
                                                            Pdb);
                                                    try {
                                                      insertProduct(postP, Pdb);
                                                      List<Map<String, dynamic>>
                                                          productsInDB =
                                                          await fetchProductsFromDB(
                                                              Pdb);
                                                    } catch (e) {
                                                      print(
                                                          "prodErrorrrr -- > " +
                                                              e.toString());
                                                    }
                                                    // var re = await http.post(
                                                    //     Uri.parse(url),
                                                    //     body: json.encode({
                                                    //       'product_name':
                                                    //           one.text,
                                                    //       'product_date':
                                                    //           _dateController
                                                    //               .text,
                                                    //       'product_price':
                                                    //           four.text,
                                                    //       'product_quantity':
                                                    //           int.parse(
                                                    //               three.text)
                                                    //     }));
                                                    setState(() {
                                                      fetch();
                                                      isLoading = false;
                                                    });
                                                    _formKey.currentState!
                                                        .save();
                                                    Navigator.pop(context);

                                                    await fetch_transactions();
                                                    print(transactions);
                                                    bool transactionsIsEmpty =
                                                        transactions[0]
                                                                    .product_name
                                                                    .product_name ==
                                                                "No Product Added!"
                                                            ? true
                                                            : false;

                                                    Transaction postT = new Transaction(
                                                        transaction_id:
                                                            transactionsIsEmpty
                                                                ? 1
                                                                : transactions
                                                                        .length +
                                                                    1,
                                                        product_name: postP,
                                                        inorout:
                                                            "Incoming ${postP.product_quantity}");
                                                    print("ABS");
                                                    print(transactions.length);
                                                    try {
                                                      insertTransaction(
                                                          postT, Tdb);
                                                      print("SUXCEESSdftraSS");
                                                    } catch (e) {
                                                      print(
                                                          "transacErrorrrr -- > " +
                                                              e.toString());
                                                    }

                                                    // var id = re.body.substring(
                                                    //     9, re.body.length - 2);
                                                    // await http.post(
                                                    //     Uri.parse(
                                                    //         "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json"),
                                                    //     body: json.encode({
                                                    //       'product_name': {
                                                    //         'product_name':
                                                    //             one.text,
                                                    //         'product_id': id,
                                                    //         'product_date':
                                                    //             _dateController
                                                    //                 .text,
                                                    //         'product_quantity':
                                                    //             int.parse(
                                                    //                 three.text),
                                                    //         'product_price':
                                                    //             four.text,
                                                    //       },
                                                    //       'inorout':
                                                    //           "Incoming ${int.parse(three.text)}",
                                                    //     }));
                                                    print("Validated!");
                                                  } else {
                                                    print("Not Validated.");
                                                  }
                                                },
                                                child: Text('Submit'))
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget product_widget() {
    TextEditingController one = TextEditingController();
    TextEditingController three = TextEditingController();
    TextEditingController four = TextEditingController();
    final _formKey = GlobalKey<FormState>();

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
              children: products.map((pd) {
                return Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              right: 10,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent, elevation: 0),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => product_description(
                                        pd: pd,
                                      ),
                                    ));
                              },
                              child: Text("${pd.product_name}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5)),
                            ),
                          ),
                        ),
                        !(products[0].product_name == "No Product Added!")
                            ? Row(
                                children: [
                                  Text("${pd.product_quantity}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5)),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        elevation: 0,
                                        padding: EdgeInsets.only(left: 20)),
                                    label: Text(""),
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      one.text = pd.product_name;
                                      three.text =
                                          pd.product_quantity.toString();
                                      four.text = pd.product_price;
                                      _dateController2.text = pd.product_date
                                          .toString()
                                          .substring(0, 10);
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return GestureDetector(
                                              onTap: () =>
                                                  FocusScope.of(context)
                                                      .unfocus(),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  content: Stack(
                                                    overflow: Overflow.visible,
                                                    children: <Widget>[
                                                      Positioned(
                                                        right: -40,
                                                        top: -40,
                                                        child: InkResponse(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: CircleAvatar(
                                                            child: Icon(
                                                              Icons.close,
                                                            ),
                                                            backgroundColor:
                                                                Colors.purple,
                                                          ),
                                                        ),
                                                      ),
                                                      SingleChildScrollView(
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              1.2,
                                                          child: Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: <
                                                                    Widget>[
                                                                  TextFormField(
                                                                    controller:
                                                                        one,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .purple
                                                                            .withOpacity(0.5),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      labelText:
                                                                          "Name",
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .purple,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    validator:
                                                                        (value) {
                                                                      var names =
                                                                          [];
                                                                      for (int i =
                                                                              0;
                                                                          i < products.length;
                                                                          i++) {
                                                                        if (products[i].product_name !=
                                                                            pd.product_name) {
                                                                          names.add(
                                                                              products[i].product_name);
                                                                        }
                                                                      }

                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty ||
                                                                          names.contains(
                                                                              one.text)) {
                                                                        return 'Please Enter Valid Product Name';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child:
                                                                        BasicDateField2(),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        three,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .purple
                                                                            .withOpacity(0.5),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      labelText:
                                                                          "Quantity",
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .purple,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    validator:
                                                                        (value) {
                                                                      if (value == null ||
                                                                          int.tryParse(value) ==
                                                                              pd
                                                                                  .product_quantity ||
                                                                          value
                                                                              .isEmpty ||
                                                                          int.tryParse(value) ==
                                                                              null ||
                                                                          int.tryParse(value)! <
                                                                              1) {
                                                                        return 'Please Enter Valid Product Quantity';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        four,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .purple
                                                                            .withOpacity(0.5),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      labelText:
                                                                          "Price",
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .purple,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) {
                                                                        return 'Please Add Product Price';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Colors
                                                                              .purple),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              true;
                                                                        });
                                                                        if (_formKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          var id =
                                                                              pd.product_id;
                                                                          var to_change_url =
                                                                              "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names/$id.json";
                                                                          int quanitity_change =
                                                                              int.parse(three.text) - pd.product_quantity;
                                                                          var inorout = int.parse(three.text) > pd.product_quantity
                                                                              ? "Incoming $quanitity_change"
                                                                              : "Outgoing ${quanitity_change * -1}";
                                                                          if (int.parse(three.text) ==
                                                                              pd.product_quantity) {
                                                                            inorout =
                                                                                "Same 0";
                                                                          }
                                                                          try {
                                                                            updateProduct(
                                                                                pd.product_id,
                                                                                one.text,
                                                                                _dateController2.text,
                                                                                four.text,
                                                                                int.parse(three.text),
                                                                                Pdb);
                                                                          } catch (e) {
                                                                            print("Update Product Error." +
                                                                                e.toString());
                                                                          }
                                                                          // await http.patch(
                                                                          //     Uri.parse(to_change_url),
                                                                          //     body: json.encode({
                                                                          //       'product_name': one.text,
                                                                          //       'product_date': _dateController2.text,
                                                                          //       'product_price': four.text,
                                                                          //       'product_quantity': int.parse(three.text)
                                                                          //     }));
                                                                          // await http.post(
                                                                          //     Uri.parse("https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json"),
                                                                          //     body: json.encode({
                                                                          //       'product_name': {
                                                                          //         'product_name': one.text,
                                                                          //         'product_id': pd.product_id,
                                                                          //         'product_date': _dateController2.text,
                                                                          //         'product_quantity': int.parse(three.text),
                                                                          //         'product_price': four.text,
                                                                          //       },
                                                                          //   'inorout': inorout,
                                                                          // }));
                                                                          await fetch_transactions();
                                                                          print(
                                                                              transactions);
                                                                          bool transactionsIsEmpty = transactions[0].product_name.product_name == "No Product Added!"
                                                                              ? true
                                                                              : false;

                                                                          Transaction postupdateT = new Transaction(
                                                                              transaction_id: transactionsIsEmpty ? 1 : transactions.length + 1,
                                                                              product_name: Product(
                                                                                product_name: one.text,
                                                                                product_id: pd.product_id,
                                                                                product_date: _dateController2.text,
                                                                                product_quantity: int.parse(three.text),
                                                                                product_price: four.text,
                                                                              ),
                                                                              inorout: inorout);
                                                                          try {
                                                                            insertTransaction(postupdateT,
                                                                                Tdb);
                                                                            print("SUXCEESSSS");
                                                                          } catch (e) {
                                                                            print("transacErrorrrr -- > " +
                                                                                e.toString());
                                                                          }
                                                                          print(
                                                                              fetchTransactionsFromDB(Tdb));

                                                                          setState(
                                                                              () {
                                                                            fetch();
                                                                            isLoading =
                                                                                false;
                                                                          });
                                                                          _formKey
                                                                              .currentState!
                                                                              .save();
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          'Submit'))
                                                                ],
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        elevation: 0,
                                        padding: EdgeInsets.only(right: 0)),
                                    label: Text(""),
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      // var id = pd.product_id;

                                      // var delete_url =
                                      //     "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names/$id.json";

                                      setState(() {
                                        isLoading = true;
                                      });
                                      // post a delete transaction
                                      var inorout =
                                          "Outgoing ${pd.product_quantity}";
                                      await fetch_transactions();
                                      bool transactionsIsEmpty = transactions[0]
                                                  .product_name
                                                  .product_name ==
                                              "No Product Added!"
                                          ? true
                                          : false;
                                      Transaction postdeleteT = new Transaction(
                                          transaction_id: transactionsIsEmpty
                                              ? 1
                                              : transactions.length + 1,
                                          product_name: Product(
                                            product_name: pd.product_name,
                                            product_id: pd.product_id,
                                            product_date:
                                                pd.product_date.toString(),
                                            product_quantity:
                                                pd.product_quantity,
                                            product_price: pd.product_price,
                                          ),
                                          inorout: inorout);
                                      try {
                                        insertTransaction(postdeleteT, Tdb);
                                        print("SUXCEESSSS insert delete t");
                                      } catch (e) {
                                        print("transacErrorrrr --delete > " +
                                            e.toString());
                                      }

                                      try {
                                        deleteProduct(pd.product_name, Pdb);
                                        print("SUXCEESSSS DELETE");
                                      } catch (e) {
                                        print("deleteErrorrrr -- > " +
                                            e.toString());
                                      }

                                      // await http.post(
                                      //     Uri.parse(
                                      //         "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json"),
                                      //     body: json.encode({
                                      //       'product_name': {
                                      //         'product_name': pd.product_name,
                                      //         'product_id': pd.product_id,
                                      //         'product_date':
                                      //             pd.product_date.toString(),
                                      //         'product_quantity':
                                      //             pd.product_quantity,
                                      //         'product_price': pd.product_price,
                                      //       },
                                      //       'inorout': inorout,
                                      //     }));
                                      // await http.delete(Uri.parse(delete_url));
                                      // await fetch();
                                      await fetch();
                                      setState(() {
                                        products = products;
                                        isLoading = false;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Text(''),
                      ],
                    ));
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

  // Widget delete_all_products() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Container(
  //         height: 80,
  //         // decoration: BoxDecoration(
  //         //   border: Border.all(width: 1, color: Colors.black),
  //         // ),
  //         width: MediaQuery.of(context).size.width,
  //         child: Center(
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 20.0, top: 10),
  //             child: ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 primary: Colors.purple.withOpacity(0.5),
  //               ),
  //               onPressed: () async {
  //                 setState(() {
  //                   isLoading = true;
  //                 });
  //                 var url_to_delete = "";
  //                 for (int i = 0; i < products.length; i++) {
  //                   await http.delete(Uri.parse(
  //                       "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names/${products[i].product_id}.json"));
  //                 }
  //
  //                 setState(() {
  //                   fetch();
  //                   isLoading = false;
  //                 });
  //               },
  //               child: Text(
  //                 'Delete All Products',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     letterSpacing: 1),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        'Enter Date',
        style: TextStyle(
          color: Colors.purple.shade200,
          fontWeight: FontWeight.bold,
        ),
      ),
      DateTimeField(
        initialValue: DateTime.now(),
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        controller: _dateController,
        style: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}

class BasicDateField2 extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        controller: _dateController2,
        style: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}
