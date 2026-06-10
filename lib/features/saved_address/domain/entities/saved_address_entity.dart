import 'package:equatable/equatable.dart';

class SavedAddressEntity extends Equatable {

  final String? street;
  final String? phone;
  final String? city;
  final String? lat;
  final String? long;
  final String? username;

  const SavedAddressEntity({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,

  });
  @override
  List<Object?> get props => [
    street ,
    phone,
    city,
    lat,
    long,
    username,

  ];
}
