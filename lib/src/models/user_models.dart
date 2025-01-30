sealed class User {
  final String uid;
  final String username;
  final String location;

  User({required this.uid, required this.username, required this.location});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'uid': String _,
        'username': String _,
        'location': String _,
        'type': "normalUser",
      } =>
        NormalUser.fromJson(json),
      {
        'uid': String _,
        'username': String _,
        'location': String _,
        'type': "adminUser",
      } =>
        AdminUser.fromJson(json),
      {
        'uid': String _,
        'username': String _,
        'location': String _,
        'type': "paidUser",
      } =>
        PaidUser.fromJson(json),
      _ => throw Exception('Invalid user type'),
    };
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'location': location,
  };
}

class NormalUser extends User {
  final String type;

  NormalUser({
    required super.uid,
    required super.username,
    required super.location,
    required this.type,
  });

  factory NormalUser.fromJson(Map<String, dynamic> json) => NormalUser(
    uid: json['uid'] as String,
    username: json['username'] as String,
    location: json['location'] as String,
    type: json['type'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'type': type};
}

class AdminUser extends User {
  final String type;

  AdminUser({
    required super.uid,
    required super.username,
    required super.location,
    required this.type,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    uid: json['uid'] as String,
    username: json['username'] as String,
    location: json['location'] as String,
    type: json['type'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'type': type};
}

class PaidUser extends User {
  final String type;

  PaidUser({
    required super.uid,
    required super.username,
    required super.location,
    required this.type,
  });

  factory PaidUser.fromJson(Map<String, dynamic> json) => PaidUser(
    uid: json['uid'] as String,
    username: json['username'] as String,
    location: json['location'] as String,
    type: json['type'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'type': type};
}
