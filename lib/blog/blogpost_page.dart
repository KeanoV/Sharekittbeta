import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharekitterbeta/models/blob.dart';
import 'package:sharekitterbeta/screens/view_image.dart';
import 'package:sharekitterbeta/services/database_service.dart';
import 'package:sharekitterbeta/utils/firebase.dart';
import 'package:sharekitterbeta/widgets/indicators.dart';

import 'BlogPostDetails.dart';

class BlogPostPage extends StatefulWidget {
  final String blogPostId;
  final String uid;
  final BlogModel blog;

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  BlogPostPage({this.blogPostId, this.uid, this.blog});

  @override
  _BlogPostPageState createState() => _BlogPostPageState();
}

class _BlogPostPageState extends State<BlogPostPage> {
  BlogPostDetails blogPostDetails = new BlogPostDetails();
  bool _isLoading = true;
  bool _isLiked;
  DocumentReference blogPostRef;
  DocumentSnapshot blogPostSnap;

  @override
  void initState() {
    super.initState();
    _getBlogPostDetails();
  }

  _getBlogPostDetails() async {
    await DatabaseService(uid: widget.currentUserId())
        .getBlogPostDetails(widget.blogPostId)
        .then((res) {
      setState(() {
        blogPostDetails = res;
        _isLoading = false;
      });
    });

    blogPostRef =
        Firestore.instance.collection('blogPosts').document(widget.blogPostId);
    blogPostSnap = await blogPostRef.get();

    List<dynamic> likedBy = blogPostSnap.data()['likedBy'];
    if (likedBy.contains(widget.currentUserId())) {
      setState(() {
        _isLiked = true;
      });
    } else {
      setState(() {
        _isLiked = false;
      });
    }

    print(blogPostSnap.data);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? circularProgress(context)
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text(blogPostDetails.blogPostTitle),
            ),
            body: Center(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              children: <Widget>[
                Text(blogPostDetails.blogPostTitle,
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Published on - ${blogPostDetails.date}',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                    GestureDetector(
                      onTap: () async {
                        buildLikeButton();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            StreamBuilder(
                              stream: likesRef
                                  .where('blogPostId',
                                      isEqualTo: firebaseAuth.currentUser.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  QuerySnapshot snap = snapshot.data;
                                  List<DocumentSnapshot> docs = snap.docs;
                                  return buildLikesCount(
                                      context, docs?.length ?? 0);
                                } else {
                                  return buildLikesCount(context, 0);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40.0),
                Text(blogPostDetails.blogPostContent,
                    style: TextStyle(fontSize: 16.0)),
              ],
            )),
          );
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      ),
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: likesRef
          .where('postId', isEqualTo: 'postId')
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot?.data?.docs ?? [];
          return IconButton(
            onPressed: () {
              if (docs.isEmpty) {
                likesRef.add({
                  'userId': currentUserId(),
                  'postId': widget.blogPostId,
                  'dateCreated': Timestamp.now(),
                });
              } else {
                likesRef.doc(docs[0].id).delete();
              }
            },
            icon: docs.isEmpty
                ? Icon(
                    CupertinoIcons.heart,
                  )
                : Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  ),
          );
        }
        return Container();
      },
    );
  }
}
