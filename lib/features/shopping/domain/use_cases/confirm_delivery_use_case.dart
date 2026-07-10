import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConfirmDeliveryUseCase {
  final ShoppingRepositoryContract _repository;

  ConfirmDeliveryUseCase(this._repository);

  Future<void> execute(String orderId) => _repository.confirmDelivery(orderId);
}
