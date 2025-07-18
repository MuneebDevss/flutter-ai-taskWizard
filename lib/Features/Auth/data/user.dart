import 'package:hive/hive.dart';
part 'user_model.g.dart'; // This will be generated

class UserModel {
  final String id;
  final String email;
  final String userName;
  final String phoneNumber;
  final String? password;
  String profilePicture;

  UserModel(
    this.id, {
    required this.email,
    required this.userName,
    required this.phoneNumber,
    this.password,
    required this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'user_name': userName,
        'phone_number': phoneNumber,
        'profile_picture': profilePicture,
      };

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        data['id'],
        email: data['email'],
        userName: data['user_name'],
        phoneNumber: data['phone_number'],
        profilePicture: data['profile_picture'],
      );

  UserModel copyWith({
    String? iid,
    String? email,
    String? userName,
    String? phoneNumber,
    String? password,
    String? profilePicture,
  }) {
    return UserModel(
      iid ?? id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
