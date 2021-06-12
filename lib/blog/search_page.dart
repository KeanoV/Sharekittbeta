
import 'package:flutter/material.dart';
import 'package:sharekitterbeta/blog/widgets/search_blogposts.dart';
import 'package:sharekitterbeta/blog/widgets/search_users.dart';

 class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(  
      length: 2,  
      child: Scaffold(  
        appBar: AppBar(  
          title: Text('Search'), 
          elevation: 0.0, 
          bottom: TabBar(  
            tabs: [  
              Tab(text: "Posts"),  
              Tab(text: "Users")
            ],  
          ),  
        ),  
        body: TabBarView(  
          children: [  
            SearchBlogPosts(),  
            SearchUsers(),  
          ],  
        ),  
      ),
    );
  }
}