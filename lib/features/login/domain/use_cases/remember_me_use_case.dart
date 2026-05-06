import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class RememberMeUseCase {
  final AuthManager _authManager;

  RememberMeUseCase(this._authManager);

  Future<void> call({
    required AuthResponseEntity authResponseEntity,
    required bool rememberMe,
  }) async {
    final token = authResponseEntity.token ?? '';
    final userId = authResponseEntity.user?.id;

    await _authManager.setAuthData(
      token: token,
      rememberMe: rememberMe,
      userId: userId,
    );
  }
}
