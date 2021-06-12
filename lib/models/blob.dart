import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  String id;
  String postId;
  String bownerId;
  String username;
  String location;
  String description;
  String mediaUrl;
  // dynamic likesCount;
  // dynamic likes;
  Timestamp timestamp;
  

  BlogModel({
    this.id,
    this.postId,
    this.bownerId,
    this.location,
    this.description,
    this.mediaUrl,
    // this.likesCount,
    // this.likes,
    this.username,
    this.timestamp,
  });
  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    bownerId = json['bownerId'];
    location = json['location'];
    username= json['username'];
    description = json['description'];
    mediaUrl = json['mediaUrl'];
    // likesCount = json['likes'].length ?? 0;
    // likes = json['likes'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['bownerId'] = this.bownerId;
    data['location'] = this.location;
    data['description'] = this.description;
    data['mediaUrl'] = this.mediaUrl;
    // data['likesCount']= this.likesCount;
    // data['likes'] = this.likes;
    data['timestamp'] = this.timestamp;
    data['username'] = this.username;
    return data;
  }
}
