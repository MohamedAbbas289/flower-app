import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCheckoutSessionUseCase {
  final ShoppingRepositoryContract _repo;

  GetCheckoutSessionUseCase(this._repo);

  Future<BaseResponse<CheckoutSessionEntity>> call(
    PaymentRequestModel requestModel,
  ) async {
    return await _repo.createCheckoutSession(requestModel);
  }
}
