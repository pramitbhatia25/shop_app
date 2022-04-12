import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/screens/product_description.dart';
import 'search_product.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class search_product extends StatefulWidget {
  static const routeName = '/search_product';

  @override
  State<search_product> createState() => _search_productState();
}

TextEditingController _dateController = TextEditingController();

class _search_productState extends State<search_product> {
  bool isLoading = true;
  List<Product> products = [];
  List<Product> searched_products = [];
  static const url =
      "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
  double height_of_container = 100;

  @override
  void initState() {
    fetch();
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
                search_prod_title(),
                search_bar(),
                product_widget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget search_prod_title() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        height: 110,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text('Search Product!',
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

  bool isIn(String a, String b) {
    return b.contains(a);
  }

  Widget search_bar() {
    TextEditingController one = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  onChanged: (text) async {
                    searched_products = [];
                    setState(() {
                      searched_products = [];
                    });

                    if (products.length == 1 &&
                        products[0].product_name == "No Product Added!") {
                      searched_products.add(products[0]);
                    } else {
                      for (int i = 0; i < products.length; i++) {
                        if (isIn(
                            text.toLowerCase(),
                            products[i]
                                .product_name
                                .toString()
                                .toLowerCase())) {
                          searched_products.add(products[i]);
                        }
                      }
                    }

                    if (text == "") {
                      searched_products = [];
                    }

                    setState(() {
                      searched_products = searched_products;
                      height_of_container = (searched_products.length) * 100;
                    });
                  },
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1)),
                  decoration: InputDecoration(
                    hintStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            wordSpacing: 2,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -2)),
                    label: Text("I'm looking for....."),
                    labelStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            wordSpacing: 2,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -2)),
                  ),
                ),
              ),
            ),
            Icon(
              Icons.search,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget product_widget() {
    TextEditingController one = TextEditingController();
    TextEditingController two = TextEditingController();
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
              children: searched_products.map((pd) {
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
                        !(products.length == 1 &&
                                products[0].product_name == "No Product Added!")
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
                                      _dateController.text = pd.product_date
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
                                                                      labelText:
                                                                          "Name",
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .purple
                                                                            .withOpacity(0.5),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
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
                                                                              value)) {
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
                                                                        BasicDateField(),
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
                                                                              color: Colors.purple.withOpacity(0.5),
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            labelText:
                                                                                "Quantity"),
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
                                                                              .isEmpty ||
                                                                          int.tryParse(value) ==
                                                                              pd
                                                                                  .product_quantity ||
                                                                          int.tryParse(value) ==
                                                                              null) {
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
                                                                      labelText:
                                                                          "Price",
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .purple
                                                                            .withOpacity(0.5),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
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
                                                                        return 'Please Change Product Price';
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
                                                                          await http.patch(
                                                                              Uri.parse(to_change_url),
                                                                              body: json.encode({
                                                                                'product_name': one.text,
                                                                                'product_date': _dateController.text,
                                                                                'product_price': four.text,
                                                                                'product_quantity': int.parse(three.text)
                                                                              }));
                                                                          await http.post(
                                                                              Uri.parse("https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json"),
                                                                              body: json.encode({
                                                                                'product_name': {
                                                                                  'product_name': one.text,
                                                                                  'product_id': pd.product_id,
                                                                                  'product_date': _dateController.text,
                                                                                  'product_quantity': int.parse(three.text),
                                                                                  'product_price': four.text,
                                                                                },
                                                                                'inorout': inorout,
                                                                              }));

                                                                          setState(
                                                                              () {
                                                                            fetch();
                                                                            searched_products =
                                                                                searched_products;
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
                                      var id = pd.product_id;

                                      var delete_url =
                                          "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names/$id.json";

                                      setState(() {
                                        isLoading = true;
                                      });
                                      var inorout =
                                          "Outgoing ${pd.product_quantity}";
                                      await http.post(
                                          Uri.parse(
                                              "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json"),
                                          body: json.encode({
                                            'product_name': {
                                              'product_name': pd.product_name,
                                              'product_id': pd.product_id,
                                              'product_date':
                                                  pd.product_date.toString(),
                                              'product_quantity':
                                                  pd.product_quantity,
                                              'product_price': pd.product_price,
                                            },
                                            'inorout': inorout,
                                          }));
                                      await http.delete(Uri.parse(delete_url));
                                      searched_products.removeWhere(
                                          (pd) => pd.product_id == id);

                                      setState(() {
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
}

class BasicDateField extends StatelessWidget {
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
        controller: _dateController,
        style: TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}
