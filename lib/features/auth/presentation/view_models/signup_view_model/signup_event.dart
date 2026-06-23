import '../../../api/request_models/signup_request_model.dart';

sealed class SignupEvent {}

class EnableAutoValidateEvent extends SignupEvent {}

class SignupRequestEvent extends SignupEvent {
  final SignupRequestModel requestModel;
  SignupRequestEvent({required this.requestModel});
}
