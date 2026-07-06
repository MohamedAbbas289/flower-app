import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConfirmDeliveryUseCase {
  final FirestoreService _firestoreService;

  ConfirmDeliveryUseCase(this._firestoreService);

  Future<void> execute(String orderId) => _firestoreService.confirmDelivery(orderId);
}
