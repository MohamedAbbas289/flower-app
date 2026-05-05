import 'package:flower_app/features/login/api/responses/login_response.dart';

class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? role;

  const UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
  });

  factory UserModel.fromResponse(UserResponse response) {
    return UserModel(
      id: response.id,
      firstName: response.firstName,
      lastName: response.lastName,
      email: response.email,
      gender: response.gender,
      phone: response.phone,
      photo: response.photo,
      role: response.role,
    );
  }
}

class LoginModel {
  final String? message;
  final String? token;
  final UserModel? user;

  const LoginModel({this.message, this.token, this.user});

  factory LoginModel.fromResponse(LoginResponse response) {
    return LoginModel(
      message: response.message,
      token: response.token,
      user: response.user != null
          ? UserModel.fromResponse(response.user!)
          : null,
    );
  }
}
