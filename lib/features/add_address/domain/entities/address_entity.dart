import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {

   final String? street;
  final String? phone;
  final String? city;
  final String? lat;
  final String? long;
  final String? username;
  final String? id;
  const AddressEntity({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,
    this.id,
  });
  @override
  List<Object?> get props => [
    street ,
    phone,
    city,
    lat,
    long,
    username,
    id,
  ];
}
