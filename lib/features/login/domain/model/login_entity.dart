import 'package:flower_app/features/login/data/model/login_model.dart';

class UserEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? role;

  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
  });

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      gender: model.gender,
      phone: model.phone,
      photo: model.photo,
      role: model.role,
    );
  }
}

class LoginEntity {
  final String? message;
  final String? token;
  final UserEntity? user;

  const LoginEntity({this.message, this.token, this.user});

  factory LoginEntity.fromModel(LoginModel model) {
    return LoginEntity(
      message: model.message,
      token: model.token,
      user: model.user != null ? UserEntity.fromModel(model.user!) : null,
    );
  }
}
