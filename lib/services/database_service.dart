import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharekitterbeta/blog/BlogPostDetails.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  // update user data
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.document(uid).setData({
      'userId': uid,
      'fullName': fullName,
      'email': email,
      'password': password,
      'likedPosts': []
    });
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }

  // save blog post
  Future saveBlogPost(
      String title, String author, String authorEmail, String content) async {
    DocumentReference blogPostsRef =
        await Firestore.instance.collection('blogPosts').add({
      'userId': uid,
      'blogPostId': '',
      'blogPostTitle': title,
      'blogPostTitleArray': title.toLowerCase().split(" "),
      'blogPostAuthor': author,
      'blogPostAuthorEmail': authorEmail,
      'blogPostContent': content,
      'likedBy': [],
      'createdAt': new DateTime.now(),
      'date': DateFormat.yMMMd('en_US').format(new DateTime.now())
    });

    await blogPostsRef.updateData({'blogPostId': blogPostsRef.documentID});

    return blogPostsRef.id;
  }

  // get user blog posts
  getUserBlogPosts() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance
        .collection('blogPosts')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // get blog post details
  Future getBlogPostDetails(String blogPostId) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('blogPosts')
        .where('blogPostId', isEqualTo: blogPostId)
        .get();
    BlogPostDetails blogPostDetails = new BlogPostDetails(
      blogPostTitle: snapshot.docs[0].data()['blogPostTitle'],
      blogPostAuthor: snapshot.docs[0].data()['blogPostAuthor'],
      blogPostAuthorEmail: snapshot.docs[0].data()['blogPostAuthorEmail'],
      blogPostContent: snapshot.docs[0].data()['blogPostContent'],
      date: snapshot.docs[0].data()['date'],
    );

    return blogPostDetails;
  }

  // search blogposts
  searchBlogPostsByName(String blogPostName) async {
    List<String> searchList = blogPostName.toLowerCase().split(" ");
    QuerySnapshot snapshot = await Firestore.instance
        .collection('blogPosts')
        .where('blogPostTitleArray', arrayContainsAny: searchList)
        .get();
    // print(snapshot.documents.length);

    return snapshot;
  }

  // search users by name
  searchUsersByName(String name) async {
    List<String> searchList = name.toLowerCase().split(" ");
    QuerySnapshot snapshot = await Firestore.instance
        .collection('users')
        .where('fullNameArray', arrayContainsAny: searchList)
        .get();
    print(snapshot.docs.length);

    return snapshot;
  }
}
