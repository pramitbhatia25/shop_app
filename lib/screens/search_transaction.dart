import 'package:flutter/material.dart';
import 'package:shop_app/models/transaction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../models/product.dart';
import '../widgets/getPDB.dart';
import '../widgets/getTDB.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class search_transaction extends StatefulWidget {
  static const routeName = '/search_transaction';

  @override
  State<search_transaction> createState() => _search_transactionState();
}

TextEditingController _dateController = TextEditingController();

class _search_transactionState extends State<search_transaction> {
  late sql.Database Pdb;
  late sql.Database Tdb;

  bool isLoading = true;
  List<Transaction> transactions = [];
  List<Transaction> searched_transactions = [];
  // static const url =
  //     "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/names.json";
  // static const transactions_url =
  //     "https://raghav-app-6a929-default-rtdb.asia-southeast1.firebasedatabase.app/transactions.json";

  double height_of_container = 100;

  @override
  void initState() {
    fetch_transactions();
  }

  Future<void> fetch_transactions() async {
    transactions = [];
    Pdb = await getPDB();
    Tdb = await getTDB();

    List<Map<String, dynamic>> transactionsInDB =
        await fetchTransactionsFromDB(Tdb);

    print(transactionsInDB.length);

    // final response = await http.get(Uri.parse(transactions_url));
    // var a = json.decode(response.body);
    if (transactionsInDB.length == 0) {
      Product temp = new Product(
          product_name: "No Product Added!",
          product_id: 0,
          product_date: DateTime.now().toString(),
          product_quantity: 0,
          product_price: "0");

      Transaction tempt = new Transaction(
          transaction_id: 0, product_name: temp, inorout: "None        ");
      transactions.add(tempt);

      setState(() {
        height_of_container = 100;
        transactions = transactions.reversed.toList();
        isLoading = false;
      });
    } else {
      // a = json.decode(response.body) as Map<String, dynamic>;

      var i = 0;
      for (int j = 0; j < transactionsInDB.length; j++) {
        var current_t = transactionsInDB[j];

        transactions.add(Transaction(
            transaction_id: current_t['transaction_id'],
            product_name: Product(
                product_id: current_t['product_id'],
                product_name: current_t['product_name'],
                product_date: current_t['product_date'],
                product_price: current_t['product_price'],
                product_quantity: current_t['product_quantity']),
            inorout: current_t['inorout']));
        i++;
      }
      ;
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
                search_transac_title(),
                search_bar(),
                product_widget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget search_transac_title() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        height: 110,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text('Search Transaction!',
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
                    searched_transactions = [];
                    setState(() {
                      searched_transactions = [];
                    });

                    if (transactions.length == 1 &&
                        transactions[0].product_name == "No Transactions!") {
                      searched_transactions.add(transactions[0]);
                    } else {
                      for (int i = 0; i < transactions.length; i++) {
                        if (isIn(
                            text.toLowerCase(),
                            transactions[i]
                                .product_name
                                .product_name
                                .toString()
                                .toLowerCase())) {
                          searched_transactions.add(transactions[i]);
                        }
                      }
                    }

                    if (text == "") {
                      searched_transactions = [];
                    }

                    setState(() {
                      searched_transactions = searched_transactions;
                      height_of_container =
                          (searched_transactions.length) * 100;
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
                              Text(
                                  "${in_or_out == "None    " ? "" : in_or_out == "Outgoing" ? '-' : '+'} ${in_or_out == "None    " ? "" : pd.inorout.substring(9, pd.inorout.length)}",
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
