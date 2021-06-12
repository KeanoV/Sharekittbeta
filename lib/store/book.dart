import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sharekitterbeta/store/add_sale.dart';

import 'bookmodel.dart';
import 'checkout.dart';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  List<BookData> dataList = [];
  bool searchState = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Books");
    referenceData.once().then((DataSnapshot dataSnapShot) {
      dataList.clear();

      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        BookData data = new BookData(
            values[key]['imgUrl'],
            values[key]['name'],
            values[key]['author'],
            values[key]['price'],
            values[key]['gradelevel'],
            values[key]['description'],
            key
            //key is the uploadid
            );
        dataList.add(data);
      }

      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sharekitt Feeds',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 32.0, top: 2.0, bottom: 5.0, right: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        SearchMethod(text);
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Search for a word",
                        contentPadding: const EdgeInsets.only(left: 34.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: dataList.length == 0
          ? Center(
              child: Text(
              "No Data Available",
              style: TextStyle(fontSize: 15),
            ))
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (_, index) {
                return CardUI(
                    dataList[index].imgUrl,
                    dataList[index].name,
                    dataList[index].author,
                    dataList[index].price,
                    dataList[index].uploadid,
                    index);
              }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => UploadItems()),
          );
        },
        label: const Text('Add Item'),
        icon: const Icon(CupertinoIcons.upload_circle),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget CardUI(String imgUrl, String name, String author, String price,
      String uploadId, int index) {
    return Padding(
        padding:
            EdgeInsets.only(top: 30.0, bottom: 50.0, left: 50.0, right: 50.0),
        child: InkWell(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.25),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                      )),
                  Hero(
                      tag: imgUrl,
                      child: Container(
                          height: 85.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(imgUrl),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 30.0),
                  Text(price,
                      style: TextStyle(
                          color: Colors.red[900],
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                  Text("Name of Item : $name" ?? 'Unable to Display',
                      style: TextStyle(
                          color: Colors.purple,
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('Buy Item',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Varela',
                                    color: Colors.purple,
                                    fontSize: 12.0)),
                            Text("Author : $author" ?? 'Unable to Display',
                                style: TextStyle(
                                    fontFamily: 'Varela',
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0)),
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (_) => CartOnePage()),
                                );
                              },
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: Icon(Icons.shopping_cart_sharp,
                                  color: Colors.purple, size: 20.0),
                            ),
                          ])),
                  FloatingActionButton.extended(
                    onPressed: () {},
                    label: const Text('Add Item'),
                    icon: const Icon(CupertinoIcons.upload_circle),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ]))));
  }

  void SearchMethod(String text) {
    DatabaseReference searchRef =
        FirebaseDatabase.instance.reference().child("Books");
    searchRef.once().then((DataSnapshot snapShot) {
      dataList.clear();
      var keys = snapShot.value.keys;
      var values = snapShot.value;

      for (var key in keys) {
        BookData data = new BookData(
            values[key]['imgUrl'],
            values[key]['name'],
            values[key]['author'],
            values[key]['price'],
            values[key]['gradelevel'],
            values[key]['description'],
            values[key]['price']
            //key is the uploadid
            );
        if (data.name.contains(text)) {
          dataList.add(data);
        }
      }
      Timer(Duration(seconds: 6), () {
        setState(() {
          //
        });
      });
    });
  }
}
