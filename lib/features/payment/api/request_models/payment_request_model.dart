import 'package:equatable/equatable.dart';

class PaymentViewArguments {
  final String cartId;
  final PaymentRequestModel requestModel;

  const PaymentViewArguments({
    required this.cartId,
    required this.requestModel,
  });
}

class PaymentRequestModel extends Equatable {
  final ShippingAddressRequestModel shippingAddress;

  const PaymentRequestModel({required this.shippingAddress});

  Map<String, dynamic> toJson() => {
    'shippingAddress': shippingAddress.toJson(),
  };

  @override
  List<Object?> get props => [shippingAddress];
}

class ShippingAddressRequestModel extends Equatable {
  final String street;
  final String phone;
  final String city;
  final String lat;
  final String long;

  const ShippingAddressRequestModel({
    required this.street,
    required this.phone,
    required this.city,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() => {
    'street': street,
    'phone': phone,
    'city': city,
    'lat': lat,
    'long': long,
  };

  @override
  List<Object?> get props => [street, phone, city, lat, long];
}
