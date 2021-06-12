
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sharekitterbeta/widgets/Container.dart';

import 'addcard.dart';

class CartOnePage extends StatelessWidget {
  static final String path = "lib/src/pages/ecommerce/cart1.dart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black12,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: InkWell(
          child: Column(
            children: <Widget>[
              Text(
                "Choose your Payment",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20.0),
              ShadowContainer(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.paypal,
                    color: Colors.indigo,
                  ),
                  title: Text("Paypal"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ShadowContainer(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.creditCard,
                    color: Colors.indigo,
                  ),
                  title: Text("Credit/Debit"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => CreditCard()),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(height: 20.0),
              ShadowContainer(
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.applePay,
                    color: Colors.indigo,
                  ),
                  title: Text("Apple Pay"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                child: RaisedButton(
                  elevation: 0,
                  padding: const EdgeInsets.all(24.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text("Continue"),
                  color: Colors.indigo,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
