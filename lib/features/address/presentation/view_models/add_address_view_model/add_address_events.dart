
import '../../../data/models/add_address_dto.dart';

sealed class AddAddressEvent {
  const AddAddressEvent ();
}

class LoadAddressDataEvent extends AddAddressEvent {
  const LoadAddressDataEvent();
}

class RetryLoadAddressDataEvent extends AddAddressEvent {
  const RetryLoadAddressDataEvent();
}

class AddAddressDataEvent extends AddAddressEvent {
   final AddAddressDto request;
  AddAddressDataEvent(this.request);
}


