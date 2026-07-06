import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateLanguageUseCase {
  final FirestoreService _firestoreService;
  final SecureStorageService _storageService;
  final AuthManager _authManager;

  UpdateLanguageUseCase(
    this._firestoreService,
    this._storageService,
    this._authManager,
  );

  Future<void> execute(String languageCode) async {
    await _storageService.writeLanguage(languageCode);
    final userId = _authManager.userId;
    if (userId != null && userId.isNotEmpty) {
      await _firestoreService.updateUserLanguage(
        userId: userId,
        language: languageCode,
      );
    }
  }
}
