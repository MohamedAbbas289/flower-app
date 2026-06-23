import 'package:equatable/equatable.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';

class PaymentRequestModel extends Equatable {
  final String street;
  final String phone;
  final String city;
  final String lat;
  final String long;

  const PaymentRequestModel({
    required this.street,
    required this.phone,
    required this.city,
    required this.lat,
    required this.long,
  });

  factory PaymentRequestModel.fromAddress(AddressEntity address) {
    return PaymentRequestModel(
      street: address.street ?? '',
      phone: address.phone ?? '',
      city: address.city ?? '',
      lat: address.lat ?? '',
      long: address.long ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'shippingAddress': {
      'street': street,
      'phone': phone,
      'city': city,
      'lat': lat,
      'long': long,
    },
  };

  @override
  List<Object?> get props => [street, phone, city, lat, long];
}
