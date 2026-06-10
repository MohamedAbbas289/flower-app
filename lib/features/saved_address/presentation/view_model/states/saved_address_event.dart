import '../../../../../core/entities/auth_response_entity.dart';

sealed class SavedAddressEvent {
  const SavedAddressEvent ();
}
class LoadSavedAddressEvent extends SavedAddressEvent {
  final AuthResponseEntity initialData;
  const LoadSavedAddressEvent(this.initialData);
}
class RetryLoadSavedAddressEvent extends SavedAddressEvent {
  const RetryLoadSavedAddressEvent();
}
class RefreshSavedAddressEvent extends SavedAddressEvent {
  const RefreshSavedAddressEvent();
}


