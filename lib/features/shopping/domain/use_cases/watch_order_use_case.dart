import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchOrderUseCase {
  final ShoppingRepositoryContract _repository;

  WatchOrderUseCase(this._repository);

  Stream<DocumentSnapshot> execute(String orderId) {
    return _repository.orderStream(orderId);
  }
}
