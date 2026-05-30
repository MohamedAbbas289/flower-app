import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/user_entitiy.dart';
import 'package:flower_app/features/profile/domain/use_cases/get_profile_use_cases.dart';
import 'package:flower_app/features/profile/presentation/view_model/cubit/get_profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view_model/states/get_profile_events.dart';
import 'package:flower_app/features/profile/presentation/view_model/states/get_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_view_model_test.mocks.dart';

@GenerateMocks([GetProfileUseCases])
void main() {
  late GetProfileUseCases getProfileUseCases;

  setUpAll(() {
    provideDummy<BaseResponse<GetUserEntity>>(
      SuccessBaseResponse<GetUserEntity>(
        data: GetUserEntity(
          id: '1',
          firstName: 'test',
          lastName: 'test',
          email: 'test',
          password: 'test',
          gender: 'test',
          phone: 'test',
          photo: 'test',
          role: 'test',
        ),
      ),
    );

    provideDummy<BaseResponse<GetUserEntity>>(
      ErrorBaseResponse<GetUserEntity>(exception: Exception()),
    );
  });

  setUp(() {
    getProfileUseCases = MockGetProfileUseCases();
  });

  group('Get Profile Data Test Group', () {
    blocTest<GetProfileViewModel, GetProfileState>(
      'emits loading then success when profile loads with empty data',
      build: () {
        when(getProfileUseCases()).thenAnswer(
          (_) async =>
              SuccessBaseResponse<GetUserEntity>(data: const GetUserEntity()),
        );
        return GetProfileViewModel(getProfileUseCases);
      },
      act: (viewModel) => viewModel.doEvent(const LoadProfileDataEvent()),
      wait: const Duration(milliseconds: 1),
      expect: () => [
        const GetProfileState(getProfileState: BaseState(isLoading: true)),
        const GetProfileState(
          getProfileState: BaseState<GetUserEntity>(
            isLoading: false,
            data: GetUserEntity(),
          ),
        ),
      ],
      verify: (_) {
        verify(getProfileUseCases()).called(1);
      },
    );

    blocTest<GetProfileViewModel, GetProfileState>(
      'emits loading then error when profile load fails',
      build: () {
        final response = ErrorBaseResponse<GetUserEntity>(
          exception: Exception(),
        );
        when(getProfileUseCases()).thenAnswer((_) async => response);
        return GetProfileViewModel(getProfileUseCases);
      },
      act: (viewModel) => viewModel.doEvent(const LoadProfileDataEvent()),
      wait: const Duration(milliseconds: 1),
      expect: () {
        final response = ErrorBaseResponse<GetUserEntity>(
          exception: Exception(),
        );
        return [
          const GetProfileState(getProfileState: BaseState(isLoading: true)),
          GetProfileState(
            getProfileState: BaseState<GetUserEntity>(
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

    blocTest<GetProfileViewModel, GetProfileState>(
      'emits loading then success when profile loads with data',
      build: () {
        const user = GetUserEntity(
          id: '1',
          firstName: 'test',
          lastName: 'user',
          email: 'test@example.com',
          password: 'password',
          gender: 'male',
          phone: '01000000000',
          photo: 'photo.png',
          role: 'user',
        );
        when(getProfileUseCases()).thenAnswer(
          (_) async => SuccessBaseResponse<GetUserEntity>(data: user),
        );
        return GetProfileViewModel(getProfileUseCases);
      },
      act: (viewModel) => viewModel.doEvent(const LoadProfileDataEvent()),
      wait: const Duration(milliseconds: 1),
      expect: () => [
        const GetProfileState(getProfileState: BaseState(isLoading: true)),
        const GetProfileState(
          getProfileState: BaseState<GetUserEntity>(
            isLoading: false,
            data: GetUserEntity(
              id: '1',
              firstName: 'test',
              lastName: 'user',
              email: 'test@example.com',
              password: 'password',
              gender: 'male',
              phone: '01000000000',
              photo: 'photo.png',
              role: 'user',
            ),
          ),
        ),
      ],
      verify: (_) {
        verify(getProfileUseCases()).called(1);
      },
    );

    test('Use case returns success response', () async {
      when(getProfileUseCases()).thenAnswer(
        (_) async =>
            SuccessBaseResponse<GetUserEntity>(data: const GetUserEntity()),
      );

      final result = await getProfileUseCases();

      expect(result, isA<SuccessBaseResponse<GetUserEntity>>());

      expect((result as SuccessBaseResponse<GetUserEntity>).data, isNotNull);
    });

    test('Use case returns error response', () async {
      when(getProfileUseCases()).thenAnswer(
        (_) async => ErrorBaseResponse<GetUserEntity>(exception: Exception()),
      );

      final result = await getProfileUseCases();

      expect(result, isA<ErrorBaseResponse<GetUserEntity>>());
    });
  });
}
