import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? role;
  final List<dynamic>? wishlist;
  final List<dynamic>? addresses;
  final DateTime? createdAt;

  const UserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.wishlist,
    this.id,
    this.addresses,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    gender,
    phone,
    photo,
    role,
    wishlist,
    id,
    addresses,
    createdAt,
  ];
}
