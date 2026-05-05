import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/features/login/domain/model/login_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class RememberMeUseCase {
  final AuthManager _authManager;

  RememberMeUseCase(this._authManager);

  Future<void> call({
    required LoginEntity loginEntity,
    required bool rememberMe,
  }) async {
    final token = loginEntity.token ?? '';
    final userId = loginEntity.user?.id;

    await _authManager.setAuthData(
      token: token,
      rememberMe: rememberMe,
      userId: userId,
    );
  }
}
