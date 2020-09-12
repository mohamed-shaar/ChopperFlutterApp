import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:chopper_trial/data/post_api_service.dart';
import 'package:chopper_trial/model/built_post.dart';
import 'package:chopper_trial/screens/SinglePostPage.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  _setupLogging();
  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print('${event.level.name}: ${event.time}: ${event.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PostApiService.create(),
      dispose: (context, PostApiService service) => service.client.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chopper Trial',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  FutureBuilder<Response> _buildBody(BuildContext context) {
    return FutureBuilder<Response<BuiltList<BuiltPost>>>(
      future: Provider.of<PostApiService>(context).getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }
          // final List posts = json.decode(snapshot.data.bodyString);
          final BuiltList<BuiltPost> posts = snapshot.data.body;
          return _buildPosts(context, posts);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _buildPosts(BuildContext context, BuiltList<BuiltPost> posts) {
    return ListView.builder(
      itemCount: posts.length,
      padding: EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              posts[index].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              posts[index].body,
            ),
            onTap: () => _navigateToPost(context, posts[index].id),
          ),
        );
      },
    );
  }

  void _navigateToPost(BuildContext context, int id) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SinglePostPage(postId: id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chopper Blog'),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newPost = BuiltPost((b)=> b..title = 'New Title' ..body = 'New Body');
          final response =
              await Provider.of<PostApiService>(context, listen: false)
                  .postPost(newPost);
          print(response.body);
        },
      ),
    );
  }
}
