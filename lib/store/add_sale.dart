import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharekitterbeta/store/book.dart';
import 'package:sharekitterbeta/widgets/Container.dart';

class UploadItems extends StatefulWidget {
  @override
  _UploadItemsState createState() => _UploadItemsState();
}

class _UploadItemsState extends State<UploadItems> {
  File imageFile;
  var formKey = GlobalKey<FormState>();
  String name, author, price, description, gradelevel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Your Item',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 5)),
                    ShadowContainer(
                      child: Container(
                        padding: EdgeInsets.all(50),
                        child: imageFile == null
                            ? FlatButton(
                                onPressed: () {
                                  _showDialog();
                                },
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.black,
                                ))
                            : Image.file(
                                imageFile,
                                width: 200,
                                height: 100,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 32.0, top: 2.0, bottom: 5.0, right: 32),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please write the name of Product";
                              } else {
                                name = value;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please write the Author/Material";
                              } else {
                                author = value;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                labelText: "Author",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                        left: 32.0, top: 2.0, bottom: 5.0, right: 32),
                            child: TextFormField(
                              
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please write the price of product";
                                } else {
                                  price = value;
                                }
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: "Price",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Color(0xFF000000), width: 1)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Color(0xFF000000), width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Color(0xFF000000), width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Color(0xFF000000), width: 1))),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please write the price of product";
                              } else {
                                price = value;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                labelText: "Price",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please write the price of product";
                              } else {
                                price = value;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                labelText: "Price",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color(0xFF000000), width: 1))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50.0),
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          if (imageFile == null) {
                            Fluttertoast.showToast(
                                msg: "Please select an image",
                                gravity: ToastGravity.CENTER,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 2);
                          } else {
                            upload();
                            Navigator.of(context).push(
                                CupertinoPageRoute(builder: (_) => Book()));
                          }
                        },
                        label: const Text('Upload Item'),
                        icon: const Icon(CupertinoIcons.upload_circle),
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text("You want take a photo from ?"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallary"),
                    onTap: () {
                      openGallary();
                    },
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      openCamera();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> openGallary() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  Future<void> upload() async {
    if (formKey.currentState.validate()) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images")
          .child(new DateTime.now().millisecondsSinceEpoch.toString() +
              "." +
              imageFile.path);
      UploadTask uploadTask = reference.putFile(imageFile);

      var imageUrl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();

      String url = imageUrl.toString();
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child("Books");
      String uploadId = databaseReference.push().key;
      HashMap map = new HashMap();
      map["name"] = name;
      map["author"] = author;
      map["price"] = price;
      map["imgUrl"] = url;
      map["description"] = description;
      map["gradelevel"] = gradelevel;

      databaseReference.child(uploadId).set(map);
    }
  }
}
