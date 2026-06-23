import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/payment/domain/repo_contract/payment_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCheckoutSessionUseCase {
  final PaymentRepoContract _repo;

  GetCheckoutSessionUseCase(this._repo);

  Future<BaseResponse<CheckoutSessionEntity>> call(
    PaymentRequestModel requestModel,
  ) async {
    return await _repo.createCheckoutSession(requestModel);
  }
}
