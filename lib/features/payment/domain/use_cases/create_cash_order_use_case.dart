import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/repo_contract/payment_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateCashOrderUseCase {
  final PaymentRepoContract _repo;

  CreateCashOrderUseCase(this._repo);

  Future<BaseResponse<CashOrderEntity>> call(
    PaymentRequestModel requestModel,
  ) async {
    return await _repo.createCashOrder(requestModel);
  }
}
