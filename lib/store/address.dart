import 'package:flutter/material.dart';
import 'package:sharekitterbeta/screens/mainscreen.dart';
import 'package:sharekitterbeta/widgets/Container.dart';

class Addresses extends StatelessWidget {
  const Addresses({Key key}) : super(key: key);

  static const String _title = 'Add Your Address';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        title: _title,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
          _title,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
            elevation: 0.0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20.0),
              child: Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.home_outlined,
                        color: Colors.indigo,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            centerTitle: true,
          ),
          body: const MyStatefulWidget(),
          
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isSameAddress = true;
  final TextEditingController shippingAddress1 = TextEditingController();
  final TextEditingController shippingAddress2 = TextEditingController();
  final TextEditingController billingAddress1 = TextEditingController();
  final TextEditingController billingAddress2 = TextEditingController();

  final TextEditingController creditCardNumber = TextEditingController();
  final TextEditingController creditCardSecurityCode = TextEditingController();

  final TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: ListView(
        padding: EdgeInsets.all(50),
        children: <Widget>[
          const Text('Shipping address'),

          AutofillGroup(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.home_outlined)),
                      controller: shippingAddress1,
                      autofillHints: const <String>[
                        AutofillHints.streetAddressLine1
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.home_outlined)),
                      controller: shippingAddress2,
                      autofillHints: const <String>[
                        AutofillHints.streetAddressLine2
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Text('Billing address'),
          Checkbox(
            value: isSameAddress,
            onChanged: (bool newValue) {
              if (newValue != null) {
                setState(() {
                  isSameAddress = newValue;
                });
              }
            },
          ),
          if (!isSameAddress)
            AutofillGroup(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration:
                        InputDecoration(prefixIcon: Icon(Icons.home_outlined)),
                    controller: billingAddress1,
                    autofillHints: const <String>[
                      AutofillHints.streetAddressLine1
                    ],
                  ),
                  TextField(
                    decoration:
                        InputDecoration(prefixIcon: Icon(Icons.home_outlined)),
                    controller: billingAddress2,
                    autofillHints: const <String>[
                      AutofillHints.streetAddressLine2
                    ],
                  ),
                ],
              ),
            ),

          AutofillGroup(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: creditCardNumber,
                  autofillHints: const <String>[AutofillHints.creditCardNumber],
                ),
                TextField(
                  controller: creditCardSecurityCode,
                  autofillHints: const <String>[
                    AutofillHints.creditCardSecurityCode
                  ],
                ),
              ],
            ),
          ),
          const Text('Contact Phone Number'),
          // `AutofillScope`.
          SizedBox(
            child: TextField(
              decoration: InputDecoration(prefixIcon: Icon(Icons.phone)),
              controller: phoneNumber,
              autofillHints: const <String>[AutofillHints.telephoneNumber],
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return TabScreen();
                }));
              },
            ),
          )
        ],
      ),
    );
  }
}
