sealed class SavedAddressEvent {
  const SavedAddressEvent();
}

class LoadAddressesEvent extends SavedAddressEvent {
  const LoadAddressesEvent();
}

class DeleteAddressEvent extends SavedAddressEvent {
  final String id;
  const DeleteAddressEvent(this.id);
}