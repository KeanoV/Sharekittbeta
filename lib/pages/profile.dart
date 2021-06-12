import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharekitterbeta/auth/register/register.dart';
import 'package:sharekitterbeta/blog/widgets/post_tile.dart';
import 'package:sharekitterbeta/models/user.dart';
import 'package:sharekitterbeta/services/database_service.dart';
import 'package:sharekitterbeta/utils/firebase.dart';
import 'package:randomizer/randomizer.dart';

class Profile extends StatefulWidget {
  final profileId;
  final String userId;

  Profile({this.profileId, this.userId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user;
  bool isLoading = false;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  bool isToggle = true;
  bool isFollowing = false;
  UserModel users;
  final DateTime timestamp = DateTime.now();
  ScrollController controller = ScrollController();

  currentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  Stream _blogPosts = blogref.doc(firebaseAuth.currentUser.uid).snapshots();
  @override
  void initState() {
    _getUserBlogPosts();
    super.initState();
  }

  Widget noBlogPostWidget() {
    return Center(
      child: Text('This user did not publish any blog posts...'),
    );
  }

  _getUserBlogPosts() {
    DatabaseService(uid: widget.userId).getUserBlogPosts().then((snapshot) {
      setState(() {
        _blogPosts = snapshot;
      });
      print(_blogPosts);
    });
  }

  Randomizer randomizer = Randomizer();
  List<Color> colorsList = [
    Color(0xFF083663),
    Color(0xFFFE161D),
    Color(0xFF682D27),
    Color(0xFF61538D),
    Color(0xFF08363B),
    Color(0xFF319B4B),
    Color(0xFFF4D03F)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ShareKitt'),
        actions: [
          widget.profileId == firebaseAuth.currentUser.uid
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.logout_sharp,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          firebaseAuth.signOut();
                          Navigator.of(context).push(
                              CupertinoPageRoute(builder: (_) => Register()));
                        }),
                  ),
                )
              : SizedBox()
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: usersRef.doc(widget.profileId).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshots) {
            if (snapshots.hasData) {
              UserModel user = UserModel.fromJson(snapshots.data.data());
              return ListView(padding: const EdgeInsets.all(15), children: <
                  Widget>[
                Container(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user?.photoUrl),
                    radius: 150.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.only(left: 150, bottom: 10),
                  child: Text(
                    user?.username,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 150, bottom: 10),
                  child: Text(
                    user?.email,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 150, bottom: 10),
                  child: Text(
                    user?.country,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),
                  ),
                ),
                Container(
                  child: blogPostsList(),
                ),
                
              ]);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget blogPostsList() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _blogPosts,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.hasData) {
            if (snapshots.data.docs != null &&
                snapshots.data.docs.length != 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.docs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        PostTile(
                            userId: widget.userId,
                            blogPostId:
                                snapshots.data.docs[index].data()['blogPostId'],
                            blogPostTitle: snapshots.data.docs[index]
                                .data()['blogPostTitle'],
                            blogPostContent: snapshots.data.docs[index]
                                .data()['blogPostContent'],
                            date: snapshots.data.docs[index].data()['date']),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Divider(height: 0.0)),
                      ],
                    );
                  });
            } else {
              return noBlogPostWidget();
            }
          } else {
            return noBlogPostWidget();
          }
        },
      ),
    );
  }
}
