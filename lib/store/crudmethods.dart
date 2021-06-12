import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(appData) async {
    Firestore.instance.collection("Sales").add(appData).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await Firestore.instance.collection("Sales").snapshots();
  }
}
