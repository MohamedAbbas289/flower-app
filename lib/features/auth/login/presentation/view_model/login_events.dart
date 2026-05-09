
import '../../api/request_models/login_request_model.dart';

sealed class LoginEvents {}

class LoginRequestEvent extends LoginEvents {
  final LoginRequestModel requestModel;

  LoginRequestEvent({required this.requestModel});
}
