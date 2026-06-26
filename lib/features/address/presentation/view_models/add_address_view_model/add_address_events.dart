import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';

sealed class AddAddressEvent {
  const AddAddressEvent();
}

class AddAddressDataEvent extends AddAddressEvent {
  final AddAddressRequestModel request;
  AddAddressDataEvent(this.request);
}
