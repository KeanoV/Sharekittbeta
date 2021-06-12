import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharekitterbeta/Model/cardmodel.dart';
import 'package:sharekitterbeta/Model/purchase.dart';
import 'package:sharekitterbeta/services/user_service.dart';
import 'package:sharekitterbeta/store/servicesforstore/purchase_service.dart';

import '../card.dart';


enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  User get user => _user;
  Firestore _firestore = Firestore.instance;
  UserService _userService = UserService();
  CardServices _cardServices  = CardServices();
  PurchaseServices _purchaseServices = PurchaseServices();

  User _userModel;
  List<CardModel> cards = [];
  List<PurchaseModel> purchaseHistory = [];


//  we will make this variables public for now
  final formKey = GlobalKey<FormState>();
//  getter
  User get userModel => _userModel;
  bool hasStripeId = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();


  
  void hasCard(){
    hasStripeId = !hasStripeId;
    notifyListeners();
}

Future<void> loadCardsAndPurchase({String userId})async{
    cards = await _cardServices.getCards(userId: userId);
    purchaseHistory = await _purchaseServices.getPurchaseHistory(userId: userId);
  }



  void clearController(){
    name.text = "";
    password.text = "";
    email.text = "";
  }


  
}