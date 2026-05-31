import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/domain/use_cases/get_profile_data_use_cases.dart';
import 'package:flower_app/features/profile/presentation/view_model/cubit/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view_model/states/get_profile_events.dart';
import 'package:flower_app/features/profile/presentation/view_model/states/get_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_view_model_test.mocks.dart';

@GenerateMocks([GetProfileDataUseCases])
void main() {
  late MockGetProfileDataUseCases mockUseCase;
  late ProfileViewModel viewModel;

  final tAuthResponseEntity = AuthResponseEntity(
    message: 'success',
    token: 'test_token',
    user: null,
  );

  setUp(() {
    mockUseCase = MockGetProfileDataUseCases();
    viewModel = ProfileViewModel(mockUseCase);
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: tAuthResponseEntity),
    );
  });

  tearDown(() => viewModel.close());

  group('ProfileViewModel', () {
    blocTest<ProfileViewModel, GetProfileState>(
      'should emit loading then success when LoadProfileDataEvent is added',
      build: () {
        when(mockUseCase()).thenAnswer(
          (_) async => SuccessBaseResponse<AuthResponseEntity>(
            data: tAuthResponseEntity,
          ),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(const LoadProfileDataEvent()),
      expect: () => [
        GetProfileState(
          getProfileState: BaseState<AuthResponseEntity>.loading(),
        ),
        GetProfileState(
          getProfileState: BaseState<AuthResponseEntity>.success(
            tAuthResponseEntity,
          ),
        ),
      ],
    );

    blocTest<ProfileViewModel, GetProfileState>(
      'should emit loading then error when LoadProfileDataEvent is added and use case fails',
      build: () {
        when(mockUseCase()).thenAnswer(
          (_) async => ErrorBaseResponse<AuthResponseEntity>(
            exception: Exception('error'),
          ),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(const LoadProfileDataEvent()),
      expect: () => [
        GetProfileState(
          getProfileState: BaseState<AuthResponseEntity>.loading(),
        ),
        GetProfileState(
          getProfileState: BaseState<AuthResponseEntity>.error(
            'Something went wrong. Please try again later',
          ),
        ),
      ],
    );

    blocTest<ProfileViewModel, GetProfileState>(
      'should emit loading then success when RetryLoadProfileDataEvent is added',
      build: () {
        when(mockUseCase()).thenAnswer(
          (_) async => SuccessBaseResponse<AuthResponseEntity>(
            data: tAuthResponseEntity,
          ),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(const RetryLoadProfileDataEvent()),
      expect: () => [
        GetProfileState(
          getProfileState: BaseState<AuthResponseEntity>.loading(),
        ),
        GetProfileState(
          getProfileState: BaseState<AuthResponseEntity>.success(
            tAuthResponseEntity,
          ),
        ),
      ],
    );
  });
}
