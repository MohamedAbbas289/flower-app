import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateCashOrderUseCase {
  final ShoppingRepositoryContract _repo;

  CreateCashOrderUseCase(this._repo);

  Future<BaseResponse<CashOrderEntity>> execute({
    required PaymentRequestModel request,
  }) async {
    return await _repo.createCashOrder(request);
  }
}
