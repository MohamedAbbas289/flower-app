import 'dart:io';

import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/firebase/fcm_service.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/data/models/change_password_response.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/mappers/change_password_mapper.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../domain/repository_contract/profile_repo_contract.dart';
import '../data_sources_contract/profile_remote_data_source_contract.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepoImpl implements ProfileRepoContract {
  final ProfileRemoteDataSourceContract profileRemoteDataSourceContract;
  final SecureStorageService _storageService;
  final AuthManager _authManager;
  final FirestoreService _firestoreService;
  final FcmService _fcmService;

  ProfileRepoImpl(
    this.profileRemoteDataSourceContract,
    this._storageService,
    this._authManager,
    this._firestoreService,
    this._fcmService,
  );

  @override
  Future<BaseResponse<AuthResponseEntity>> getProfileData() async {
    final response = await profileRemoteDataSourceContract.getProfileData();
    switch (response) {
      case SuccessBaseResponse<AuthResponse>():
        final entity = response.data.toEntity();
        return SuccessBaseResponse<AuthResponseEntity>(data: entity);
      case ErrorBaseResponse<AuthResponse>():
        return ErrorBaseResponse<AuthResponseEntity>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<AuthResponseEntity>> editProfile(
    EditProfileRequestModel request,
  ) async {
    final response = await profileRemoteDataSourceContract.editProfile(
      request,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponse>():
        return SuccessBaseResponse<AuthResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorBaseResponse<AuthResponse>():
        return ErrorBaseResponse<AuthResponseEntity>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(File photo) async {
    return await profileRemoteDataSourceContract.uploadPhoto(photo);
  }

  @override
  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    final response = await profileRemoteDataSourceContract.changePassword(
      password: password,
      newPassword: newPassword,
    );
    switch (response) {
      case SuccessBaseResponse<ChangePasswordResponse>():
        return SuccessBaseResponse(data: response.data.toEntity());
      case ErrorBaseResponse<ChangePasswordResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    await _storageService.writeLanguage(languageCode);
    final userId = _authManager.userId;
    if (userId != null && userId.isNotEmpty) {
      await _firestoreService.updateUserLanguage(
        userId: userId,
        language: languageCode,
      );
    }
  }

  @override
  Future<bool> getNotificationsEnabled() async {
    return await _storageService.readNotificationsEnabled();
  }

  @override
  Future<void> toggleNotifications(bool value, String languageCode) async {
    await _storageService.writeNotificationsEnabled(value);
    if (value) {
      final userId = await _storageService.readUserId();
      final token = await _fcmService.getFcmToken();
      if (userId != null &&
          userId.isNotEmpty &&
          token != null &&
          token.isNotEmpty) {
        await _fcmService.saveFcmDataForUser(
          userId: userId,
          fcmToken: token,
          language: languageCode,
        );
      }
    } else {
      await _fcmService.deleteToken();
    }
  }
}
