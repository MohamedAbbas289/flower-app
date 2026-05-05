import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/features/login/domain/model/login_entity.dart';
import 'package:injectable/injectable.dart';

/// Persists the login session after a successful login based on the
/// user's "Remember Me" preference.
///
/// If [rememberMe] is true the token and user ID are written to secure
/// storage so that [AuthManager.shouldAutoLogin] returns true on the next
/// app launch. If false, the token is held only in memory for this session.
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
