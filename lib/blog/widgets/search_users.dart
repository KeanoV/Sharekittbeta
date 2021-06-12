import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomizer/randomizer.dart';
import 'package:sharekitterbeta/pages/profile.dart';
import 'package:sharekitterbeta/screens/view_image.dart';
import 'package:sharekitterbeta/services/database_service.dart';
import 'package:sharekitterbeta/utils/firebase.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

currentUserId() {
  return firebaseAuth.currentUser.uid;
}

class _SearchUsersState extends State<SearchUsers> {
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool _isLoading = false;
  bool _hasUserSearched = false;

  Randomizer randomizer = Randomizer();
  

  _initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchUsersByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        // print(searchResultSnapshot.documents.length);
        setState(() {
          _isLoading = false;
          _hasUserSearched = true;
        });
      });
    }
  }

  Widget blogPostsList() {
    return _hasUserSearched
        ? (searchResultSnapshot.docs.length == 0)
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Center(child: Text('No results found...')),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: searchResultSnapshot.docs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Profile(
                                    profileId: searchResultSnapshot
                                        .docs[index]
                                        .data()['userId'],
                                  )));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(user?.photoUrl),
                              child: Text(
                                  searchResultSnapshot.docs[index]
                                      .data()['name']
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                            ),
                            title: Text(
                              searchResultSnapshot.docs[index]
                                  .data()['fullName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 0.0)),
                    ],
                  );
                })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          color: Colors.black87,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchEditingController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      hintText: "Search users...",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: InputBorder.none),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    _initiateSearch();
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(40)),
                      child: Icon(Icons.search, color: Colors.white)))
            ],
          ),
        ),
        _isLoading
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : blogPostsList()
      ]),
    );
  }
}
