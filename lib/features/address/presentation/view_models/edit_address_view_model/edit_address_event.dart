import 'package:flower_app/features/address/data/models/add_address_dto.dart';

sealed class EditAddressEvent {
  const EditAddressEvent();
}

class SubmitEditAddressEvent extends EditAddressEvent {
  final String id;
  final AddAddressDto request;

  const SubmitEditAddressEvent({required this.id, required this.request});
}