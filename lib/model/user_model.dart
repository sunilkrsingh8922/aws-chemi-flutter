import 'package:hive_flutter/adapters.dart';
part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: "${json['firstName']} ${json['firstName']}", // must match keys
      avatar: "https://i.pravatar.cc/150?img=${json['id']}",// provide default if null
    );
  }
}
