import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharekitterbeta/Model/purchase.dart';
import 'package:sharekitterbeta/utils/firebase.dart';

class PurchaseServices {
  static const USER_ID = 'userId';

  String collection = "purchases";
  Firestore _firestore = Firestore.instance;

  void createPurchase(
      {String id,
      String productName,
      int amount,
      String userId,
      String date,
      String cardId}) {
    _firestore.collection(collection).doc(id).set({
      "id": id,
      "productName": productName,
      "amount": amount,
      "userId": userId,
      "date": DateTime.now().toString(),
      "cardId": cardId
    });
  }

  Future<List<PurchaseModel>> getPurchaseHistory({String userId}) async =>
      _firestore
          .collection("users")
          .where(USER_ID, isEqualTo: userId)
          .get()
          .then((result) {
        List<PurchaseModel> purchaseHistory = [];
        print("=== RESULT SIZE ${result.docs.length}");
        for (DocumentSnapshot item in result.docs) {
          purchaseHistory.add(PurchaseModel.fromSnapshot(item));
          print(" CARDS ${purchaseHistory.length}");
        }
        return purchaseHistory;
      });
}
