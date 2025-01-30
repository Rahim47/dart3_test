import 'package:myapp/src/models/user_models.dart';

sealed class Post {
  final String id;
  final String postType;
  final int likes;
  final User user;

  Post({
    required this.id,
    required this.postType,
    required this.likes,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String _,
        'postType': 'text',
        'likes': int _,
        'user': {'uid': String _, 'username': String _, 'location': String _},
      } =>
        TextPost.fromJson(json),
      {
        'id': String _,
        'postType': 'image',
        'likes': int _,
        'user': {'uid': String _, 'username': String _, 'location': String _},
      } =>
        ImagePost.fromJson(json),
      {
        'id': String _,
        'postType': 'video',
        'likes': int _,
        'user': {'uid': String _, 'username': String _, 'location': String _},
      } =>
        VideoPost.fromJson(json),

      _ => throw Exception('Invalid post type'),
    };
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'postType': postType,
    'likes': likes,
    'user': user.toJson(),
  };
}

class ImagePost extends Post {
  final String imagePath;

  ImagePost({
    required super.id,
    required super.likes,
    required super.user,
    required this.imagePath,
  }) : super(postType: 'image');

  factory ImagePost.fromJson(Map<String, dynamic> json) => ImagePost(
    id: json['id'],
    likes: json['likes'],
    user: User.fromJson(json['user']),
    imagePath: json['imagePath'],
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'imagePath': imagePath};
}

class TextPost extends Post {
  final String textBody;

  TextPost({
    required super.id,
    required super.likes,
    required super.user,
    required this.textBody,
  }) : super(postType: 'text');

  factory TextPost.fromJson(Map<String, dynamic> json) => TextPost(
    id: json['id'],
    likes: json['likes'],
    user: User.fromJson(json['user']),
    textBody: json['textBody'],
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'textBody': textBody};
}

class VideoPost extends Post {
  final String videoUrl;

  VideoPost({
    required super.id,
    required super.likes,
    required super.user,
    required this.videoUrl,
  }) : super(postType: 'video');

  factory VideoPost.fromJson(Map<String, dynamic> json) => VideoPost(
    id: json['id'],
    likes: json['likes'],
    user: User.fromJson(json['user']),
    videoUrl: json['videoUrl'],
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'videoUrl': videoUrl};
}
