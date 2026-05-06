import 'package:flower_app/features/signup/api/request_models/signup_request_model.dart';

sealed class SignupEvents {}

class SignupRequestEvent extends SignupEvents {
  final SignupRequestModel requestModel;
  SignupRequestEvent({required this.requestModel});
}
