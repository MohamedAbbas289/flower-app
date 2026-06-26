import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';

sealed class EditAddressEvent {
  const EditAddressEvent();
}

class SubmitEditAddressEvent extends EditAddressEvent {
  final String id;
  final AddAddressRequestModel request;

  const SubmitEditAddressEvent({required this.id, required this.request});
}
