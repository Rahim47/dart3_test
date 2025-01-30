import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myapp/src/datasource/data.dart';
import 'package:myapp/src/models/post_models.dart';
import 'package:myapp/src/models/user_models.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final List<Post> postList =
        jsonData.map((json) => Post.fromJson(json)).toList();
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: postList.length,
          itemBuilder: (context, index) {
            return PostWidget(post: postList[index]);
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PostWidget extends StatefulWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: YoutubePlayerFlags(mute: false, autoPlay: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_AuthorWidget(widget.post.user), getPostWidget(widget.post)],
    );
  }

  Widget getPostWidget(Post post) {
    return switch (post) {
      TextPost() => _textPostWidget(post),
      ImagePost() => _imagePostWidget(post),
      VideoPost() => _videoPostWidget(post),
    };
  }

  Widget _textPostWidget(TextPost post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            post.textBody,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded, color: Colors.red),
                const SizedBox(width: 8.0),
                Icon(Icons.comment, color: Colors.blueGrey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePostWidget(ImagePost post) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 8.0,
            bottom: 14.0,
          ),
          width: double.infinity,
          height: 300,
          child: Image.network(post.imagePath, fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.favorite_rounded, color: Colors.red),
              const SizedBox(width: 8.0),
              Icon(Icons.comment, color: Colors.blueGrey[200]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _videoPostWidget(VideoPost post) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 8.0,
            bottom: 14.0,
          ),
          width: double.infinity,
          height: 300,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
            onReady: () {
              log('Player is ready.');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.favorite_rounded, color: Colors.red),
              const SizedBox(width: 8.0),
              Icon(Icons.comment, color: Colors.blueGrey[200]),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthorWidget extends StatelessWidget {
  const _AuthorWidget(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey[100], // Replace with desired color
              ),
            ),
            const Icon(Icons.person_rounded, color: Colors.deepPurple),
          ],
        ),
      ),
      title: Text(
        user.username,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      contentPadding: EdgeInsets.zero, // Remove default padding
    );
  }
}
