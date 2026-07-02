import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/values/firestore_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../api/request_models/login_request_model.dart';
import '../../../domain/use_cases/login_use_case.dart';
import 'login_events.dart';
import 'login_state.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase) : super(const LoginState());
  final LoginUseCase _loginUseCase;

  void doEvent(LoginEvents event) {
    switch (event) {
      case LoginRequestEvent():
        _loginUser(requestModel: event.requestModel);
        break;
    }
  }

  Future<void> _loginUser({required LoginRequestModel requestModel}) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    final response = await _loginUseCase.execute(requestModel: requestModel);
    switch (response) {
      case SuccessBaseResponse<AuthResponseEntity>():
        emit(state.copyWith(loginState: BaseState.success(response.data)));
        _saveFcmToken(response.data.user?.id);
        break;
      case ErrorBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(loginState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }

  Future<void> _saveFcmToken(String? userId) async {
    if (userId == null || userId.isEmpty) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      await FirebaseFirestore.instance
          .collection(FirestoreKeys.usersCollection)
          .doc(userId)
          .set({FirestoreKeys.fcmToken: token}, SetOptions(merge: true));
    } catch (e, s) {
      debugPrint('FCM token save error: $e\n$s');
    }
  }
}
