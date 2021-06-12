import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharekitterbeta/blog/BlogPostDetails.dart';
import 'package:sharekitterbeta/models/user.dart';
import 'package:sharekitterbeta/services/services.dart';
import 'package:sharekitterbeta/utils/firebase.dart';
import 'package:intl/intl.dart';

class UserService extends Service {
  String currentUid() {
    return firebaseAuth.currentUser.uid;
  }

  setUserStatus(bool isOnline) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      usersRef
          .doc(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }

  updateProfile(
      {File image, String username, String bio, String country}) async {
    DocumentSnapshot doc = await usersRef.doc(currentUid()).get();
    var users = UserModel.fromJson(doc.data());
    users?.username = username;
    users?.bio = bio;
    users?.country = country;
    if (image != null) {
      users?.photoUrl = await uploadImage(profilePic, image);
    }
    await usersRef.doc(currentUid()).update({
      'username': username,
      'bio': bio,
      'country': country,
      "photoUrl": users?.photoUrl ?? '',
    });

    return true;
  }

  Future<void> updateDetails(Map<String, dynamic> values) async {
    DocumentSnapshot doc = await usersRef.doc(currentUid()).get();
    Firestore.instance.collection("users").doc(values["id"]).update(values);
  }

  // Collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  // update user data
  Future updateUserData(String name, String email, String password) async {
    var user = firebaseAuth.currentUser;
    return await userCollection.document(currentUid()).setData({
      'userId': user,
      'name': name,
      'email': email,
      'password': password,
      'likedPosts': []
    });
  }

  // get user data
  Future getUserData(String email) async {
    var user = firebaseAuth.currentUser;
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // save blog post
  Future saveBlogPost(
      String title, String author, String authorEmail, String content) async {
    var user = firebaseAuth.currentUser;
    DocumentReference blogPostsRef =
        await Firestore.instance.collection('blogPosts').add({
      'userId': user,
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

    await blogPostsRef.updateData({'blogPostId': blogPostsRef.id});

    return blogPostsRef.id;
  }

  // get user blog posts
  getUserBlogPosts() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance
        .collection('blogPosts')
        .where('userId', isEqualTo: firebaseAuth.currentUser.uid)
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
  searchUsersByName(String userName) async {
    List<String> searchList = userName.toLowerCase().split(" ");
    QuerySnapshot snapshot = await Firestore.instance
        .collection('users')
        .where('fullNameArray', arrayContainsAny: searchList)
        .get();
    print(snapshot.docs.length);

    return snapshot;
  }

  // liked blog posts
  Future togglingLikes(String blogPostId) async {
    DocumentReference userRef =
        userCollection.doc(firebaseAuth.currentUser.uid);
    DocumentSnapshot userSnap = await userRef.get();

    DocumentReference blogPostRef =
        Firestore.instance.collection('blogPosts').doc(blogPostId);

    List<dynamic> likedPosts = await userSnap.data()['likedPosts'];

    if (likedPosts.contains(blogPostId)) {
      userRef.updateData({
        'likedPosts': FieldValue.arrayRemove([blogPostId])
      });
      blogPostRef.updateData({
        'likedBy': FieldValue.arrayRemove([firebaseAuth.currentUser.uid])
      });
    } else {
      userRef.updateData({
        'likedPosts': FieldValue.arrayUnion([blogPostId])
      });
      blogPostRef.updateData({
        'likedBy': FieldValue.arrayUnion([firebaseAuth.currentUser.uid])
      });
    }
  }
}
