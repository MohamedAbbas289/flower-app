import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_events.dart';
import 'package:flower_app/features/profile/presentation/view_models/edit_profile_view_model/edit_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_view_model_test.mocks.dart';

@GenerateMocks([EditProfileUseCase, UploadPhotoUseCase])
void main() {
  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUploadPhotoUseCase mockUploadPhotoUseCase;
  late EditProfileViewModel viewModel;

  final tRequest = EditProfileRequestModel(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '01012345678',
  );

  final tAuthResponseEntity = AuthResponseEntity(
    message: 'success',
    token: 'test_token',
    user: null,
  );

  final tFile = File('assets/images/app_icon.png');

  setUp(() {
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUploadPhotoUseCase = MockUploadPhotoUseCase();
    viewModel = EditProfileViewModel(mockEditProfileUseCase, mockUploadPhotoUseCase);
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: tAuthResponseEntity),
    );
    provideDummy<BaseResponse<void>>(
      SuccessBaseResponse<void>(data: null),
    );
  });

  tearDown(() => viewModel.close());

  group('EditProfileViewModel', () {
    group('UpdateProfileEvent', () {
      blocTest<EditProfileViewModel, EditProfileState>(
        'should emit loading then success when update succeeds',
        build: () {
          when(mockEditProfileUseCase(tRequest))
              .thenAnswer((_) async => SuccessBaseResponse<AuthResponseEntity>(data: tAuthResponseEntity));
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(UpdateProfileEvent(tRequest)),
        expect: () => [
          EditProfileState(updateProfileState: BaseState<AuthResponseEntity>.loading()),
          EditProfileState(updateProfileState: BaseState<AuthResponseEntity>.success(tAuthResponseEntity)),
        ],
      );

      blocTest<EditProfileViewModel, EditProfileState>(
        'should emit loading then error when update fails',
        build: () {
          when(mockEditProfileUseCase(tRequest))
              .thenAnswer((_) async => ErrorBaseResponse<AuthResponseEntity>(exception: Exception('error')));
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(UpdateProfileEvent(tRequest)),
        expect: () => [
          EditProfileState(updateProfileState: BaseState<AuthResponseEntity>.loading()),
          EditProfileState(updateProfileState: BaseState<AuthResponseEntity>.error('somethingWentWrong')),
        ],
      );
    });

    group('UploadPhotoEvent', () {
      blocTest<EditProfileViewModel, EditProfileState>(
        'should emit loading then success when upload succeeds',
        build: () {
          when(mockUploadPhotoUseCase(tFile))
              .thenAnswer((_) async => SuccessBaseResponse<void>(data: null));
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(UploadPhotoEvent(tFile)),
        expect: () => [
          EditProfileState(uploadPhotoState: BaseState<void>.loading()),
          EditProfileState(uploadPhotoState: BaseState<void>.success(null)),
        ],
      );

      blocTest<EditProfileViewModel, EditProfileState>(
        'should emit loading then error when upload fails',
        build: () {
          when(mockUploadPhotoUseCase(tFile))
              .thenAnswer((_) async => ErrorBaseResponse<void>(exception: Exception('error')));
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(UploadPhotoEvent(tFile)),
        expect: () => [
          EditProfileState(uploadPhotoState: BaseState<void>.loading()),
          EditProfileState(uploadPhotoState: BaseState<void>.error('somethingWentWrong')),
        ],
      );
    });
  });
}