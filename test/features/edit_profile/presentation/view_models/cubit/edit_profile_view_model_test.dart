import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/edit_profile/data/models/edit_user_dto.dart';
import 'package:flower_app/features/edit_profile/domain/entities/edit_user_entity.dart';
import 'package:flower_app/features/edit_profile/domain/use_cases/edit_profile_use_cases.dart';
import 'package:flower_app/features/edit_profile/presentation/view_models/cubit/edit_profile_view_model.dart';
import 'package:flower_app/features/edit_profile/presentation/view_models/states/edit_profile_events.dart';
import 'package:flower_app/features/edit_profile/presentation/view_models/states/edit_profile_state.dart';
import 'package:flower_app/features/get_profile_screen/domain/entities/user_entitiy.dart';
import 'package:flower_app/features/get_profile_screen/domain/use_cases/get_profile_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_view_model_test.mocks.dart';

@GenerateMocks([EditProfileUseCases, GetProfileUseCases])
void main() {
  late MockEditProfileUseCases editProfileUseCases;
  late MockGetProfileUseCases getProfileUseCases;

  const profileUser = GetUserEntity(
    id: '1',
    firstName: 'Ahmed',
    lastName: 'Ali',
    email: 'ahmed@test.com',
    gender: 'male',
    phone: '+201000000000',
    photo: 'photo.png',
    role: 'user',
  );

  const updatedUser = EditUserEntity(
    id: '1',
    firstName: 'Ahmed',
    lastName: 'Ali',
    email: 'ahmed@test.com',
    gender: 'male',
    phone: '+201000000000',
    photo: 'photo.png',
    role: 'user',
  );

  final updateRequest = EditUserDto(
    firstName: 'Ahmed',
    lastName: 'Ali',
    email: 'ahmed@test.com',
    phone: '+201000000000',
  );

  setUpAll(() {
    provideDummy<BaseResponse<GetUserEntity>>(
      SuccessBaseResponse<GetUserEntity>(data: profileUser),
    );
    provideDummy<BaseResponse<GetUserEntity>>(
      ErrorBaseResponse<GetUserEntity>(exception: Exception()),
    );
    provideDummy<BaseResponse<EditUserEntity>>(
      SuccessBaseResponse<EditUserEntity>(data: updatedUser),
    );
    provideDummy<BaseResponse<EditUserEntity>>(
      ErrorBaseResponse<EditUserEntity>(exception: Exception()),
    );
  });

  setUp(() {
    editProfileUseCases = MockEditProfileUseCases();
    getProfileUseCases = MockGetProfileUseCases();
  });

  group('EditProfileViewModel', () {
    blocTest<EditProfileViewModel, UpdateProfileState>(
      'emits loading then success when profile data loads',
      build: () {
        when(getProfileUseCases()).thenAnswer(
          (_) async => SuccessBaseResponse<GetUserEntity>(data: profileUser),
        );
        return EditProfileViewModel(editProfileUseCases, getProfileUseCases);
      },
      act: (viewModel) =>
          viewModel.doEvent(const LoadUpdateProfileDataEvent()),
      expect: () => [
        const UpdateProfileState(
          profileDataState: BaseState<GetUserEntity>(isLoading: true),
        ),
        const UpdateProfileState(
          profileDataState: BaseState<GetUserEntity>(
            isLoading: false,
            data: profileUser,
          ),
          selectedGender: 'male',
        ),
      ],
      verify: (_) {
        verify(getProfileUseCases()).called(1);
        verifyNever(editProfileUseCases(updateRequest));
      },
    );

    blocTest<EditProfileViewModel, UpdateProfileState>(
      'emits loading then error when profile data load fails',
      build: () {
        final response = ErrorBaseResponse<GetUserEntity>(
          exception: Exception(),
        );
        when(getProfileUseCases()).thenAnswer((_) async => response);
        return EditProfileViewModel(editProfileUseCases, getProfileUseCases);
      },
      act: (viewModel) =>
          viewModel.doEvent(const LoadUpdateProfileDataEvent()),
      expect: () {
        final response = ErrorBaseResponse<GetUserEntity>(
          exception: Exception(),
        );
        return [
          const UpdateProfileState(
            profileDataState: BaseState<GetUserEntity>(isLoading: true),
          ),
          UpdateProfileState(
            profileDataState: BaseState<GetUserEntity>(
              isLoading: false,
              msg: response.errorMessage,
            ),
          ),
        ];
      },
      verify: (_) {
        verify(getProfileUseCases()).called(1);
      },
    );

    blocTest<EditProfileViewModel, UpdateProfileState>(
      'emits loading then success when profile update succeeds',
      build: () {
        when(editProfileUseCases(updateRequest)).thenAnswer(
          (_) async => SuccessBaseResponse<EditUserEntity>(data: updatedUser),
        );
        return EditProfileViewModel(editProfileUseCases, getProfileUseCases);
      },
      act: (viewModel) =>
          viewModel.doEvent(UpdateProfileDataEvent(updateRequest)),
      expect: () => [
        const UpdateProfileState(
          updateProfileState: BaseState<EditUserEntity>(isLoading: true),
        ),
        const UpdateProfileState(
          updateProfileState: BaseState<EditUserEntity>(
            isLoading: false,
            data: updatedUser,
          ),
          selectedGender: 'male',
        ),
      ],
      verify: (_) {
        verify(editProfileUseCases(updateRequest)).called(1);
        verifyNever(getProfileUseCases());
      },
    );

    blocTest<EditProfileViewModel, UpdateProfileState>(
      'emits loading then error when profile update fails',
      build: () {
        final response = ErrorBaseResponse<EditUserEntity>(
          exception: Exception(),
        );
        when(editProfileUseCases(updateRequest)).thenAnswer(
          (_) async => response,
        );
        return EditProfileViewModel(editProfileUseCases, getProfileUseCases);
      },
      act: (viewModel) =>
          viewModel.doEvent(UpdateProfileDataEvent(updateRequest)),
      expect: () {
        final response = ErrorBaseResponse<EditUserEntity>(
          exception: Exception(),
        );
        return [
          const UpdateProfileState(
            updateProfileState: BaseState<EditUserEntity>(isLoading: true),
          ),
          UpdateProfileState(
            updateProfileState: BaseState<EditUserEntity>(
              isLoading: false,
              msg: response.errorMessage,
            ),
          ),
        ];
      },
      verify: (_) {
        verify(editProfileUseCases(updateRequest)).called(1);
      },
    );

    blocTest<EditProfileViewModel, UpdateProfileState>(
      'changes selected gender',
      build: () =>
          EditProfileViewModel(editProfileUseCases, getProfileUseCases),
      act: (viewModel) => viewModel.changeGender('male'),
      expect: () => [
        const UpdateProfileState(selectedGender: 'male'),
      ],
    );
  });
}
