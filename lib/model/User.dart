class User {
  final String id;
  final String name;
  final String fcmToken;
  final String avatar;

  User({required this.id, required this.name, required this.fcmToken, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      avatar: "https://i.pravatar.cc/150?u=${json['id']}", // fake avatar
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'fcmToken': fcmToken, 'avatar': avatar};
  }
}
