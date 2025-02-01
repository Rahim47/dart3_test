import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myapp/src/datasource/data.dart';
import 'package:myapp/src/models/post_models.dart';
import 'package:myapp/src/models/user_models.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// [NOTE] To show debugging devices -> Cmd+Shift+P on Mac or
/// Ctrl+Shift+P on ChromeOS, Windows, or Linux => Show [DEVICE] preview

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          color: Colors.purple,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      home: const MyHomePage(title: 'Instagram'),
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
        title: Center(child: Text(title)),
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
      initialVideoId: 'nPt8bK2gbaU',
      flags: YoutubePlayerFlags(mute: false, autoPlay: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (Widget postWidget, Widget authorWidget) = _getPostWidget(
      widget.post,
    );
    return Column(children: [postWidget, authorWidget]);
  }

  (Widget, Widget) _getPostWidget(Post post) {
    return switch (post) {
      // Text posts
      TextPost(:NormalUser user) => (
        TextPostWidget(post: post),
        AuthorUserWidget(author: user),
      ),
      TextPost(:PaidUser user) => (
        TextPostWidget(post: post),
        PaidUserWidget(author: user),
      ),
      TextPost(:AdminUser user) => (
        TextPostWidget(post: post),
        AdminUserWidget(author: user),
      ),
      // Image posts
      ImagePost(:NormalUser user) => (
        ImagePostWidget(post: post),
        AuthorUserWidget(author: user),
      ),
      ImagePost(:PaidUser user) => (
        ImagePostWidget(post: post),
        PaidUserWidget(author: user),
      ),
      ImagePost(:AdminUser user) => (
        ImagePostWidget(post: post),
        AdminUserWidget(author: user),
      ),
      // Video posts
      VideoPost(:NormalUser user) => (
        VideoPostWidget(controller: _controller, post: post),
        AuthorUserWidget(author: user),
      ),
      VideoPost(:PaidUser user) => (
        VideoPostWidget(controller: _controller, post: post),
        PaidUserWidget(author: user),
      ),
      VideoPost(:AdminUser user) => (
        VideoPostWidget(controller: _controller, post: post),
        AdminUserWidget(author: user),
      ),
    };
  }
}

class PaidUserWidget extends StatelessWidget {
  const PaidUserWidget({super.key, required this.author});

  final PaidUser author;

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
      title: Row(
        children: [
          Text(
            author.username,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox.square(dimension: 6),
          const Icon(Icons.verified_rounded, color: Colors.lightBlue, size: 18),
        ],
      ),
      contentPadding: EdgeInsets.zero, // Remove default padding
    );
  }
}

class AdminUserWidget extends StatelessWidget {
  const AdminUserWidget({super.key, required this.author});

  final AdminUser author;

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
      title: Row(
        children: [
          Text(
            author.username,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox.square(dimension: 6),
          const Icon(
            Icons.verified_user_rounded,
            color: Colors.lightBlue,
            size: 18,
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero, // Remove default padding
    );
  }
}

class VideoPostWidget extends StatelessWidget {
  const VideoPostWidget({
    super.key,
    required YoutubePlayerController controller,
    required this.post,
  }) : _controller = controller;

  final YoutubePlayerController _controller;
  final VideoPost post;

  @override
  Widget build(BuildContext context) {
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

class ImagePostWidget extends StatelessWidget {
  const ImagePostWidget({super.key, required this.post});

  final ImagePost post;

  @override
  Widget build(BuildContext context) {
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
}

class AuthorUserWidget extends StatelessWidget {
  const AuthorUserWidget({super.key, required this.author});

  final NormalUser author;

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
        author.username,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      contentPadding: EdgeInsets.zero, // Remove default padding
    );
  }
}

class TextPostWidget extends StatelessWidget {
  const TextPostWidget({super.key, required this.post});

  final TextPost post;

  @override
  Widget build(BuildContext context) {
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
}
