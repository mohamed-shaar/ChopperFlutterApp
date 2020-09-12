import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:chopper_trial/data/post_api_service.dart';
import 'package:chopper_trial/model/built_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SinglePostPage extends StatelessWidget {
  final int postId;

  SinglePostPage({this.postId});

  Padding _buildPost(BuiltPost post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            post.title,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(post.body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chopper Blog'),
      ),
      body: FutureBuilder<Response<BuiltPost>>(
        future: Provider.of<PostApiService>(context).getPostWithId(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // final Map post = json.decode(snapshot.data.bodyString);
            final post = snapshot.data.body;
            return _buildPost(post);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
