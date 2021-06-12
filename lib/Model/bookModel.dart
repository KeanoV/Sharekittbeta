import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String bookuid;
  String name;
  String author;
  int length;
  Timestamp dateCompleted;

  BookModel({
    this.bookuid,
    this.name,
    this.length,
    this.dateCompleted,
  });

  BookModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    bookuid = doc.data()["uid"];
    name = doc.data()["name"];
    author = doc.data()["author"];
    length = doc.data()["length"];
    dateCompleted = doc.data()['dateCompleted'];
  }
}
