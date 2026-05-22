import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/domain/entity/change_password_entity.dart';
import 'package:flower_app/features/change_password/domain/use_case/change_password_use_case.dart';
import 'package:flower_app/features/change_password/presentation/change_password_view_model/cubit/change_password_view_model.dart';
import 'package:flower_app/features/change_password/presentation/change_password_view_model/events/change_password_events.dart';
import 'package:flower_app/features/change_password/presentation/change_password_view_model/states/change_password_states.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'change_password_view_model_test.mocks.dart';

@GenerateMocks([ChangePasswordUseCase])
void main() {
  late ChangePasswordViewModel viewModel;
  late MockChangePasswordUseCase mockUseCase;

  final tEntity = ChangePasswordEntity(
    message: 'Password changed successfully',
    token: 'new_token_123',
  );

  setUpAll(() {
    provideDummy<BaseResponse<ChangePasswordEntity>>(
      SuccessBaseResponse<ChangePasswordEntity>(data: tEntity),
    );
    provideDummy<BaseResponse<ChangePasswordEntity>>(
      ErrorBaseResponse<ChangePasswordEntity>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockUseCase = MockChangePasswordUseCase();
    viewModel = ChangePasswordViewModel(mockUseCase);
  });

  tearDown(() => viewModel.close());

  group('EnableAutoValidateEvent', () {
    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'emits autoValidate true',
      build: () => viewModel,
      act: (vm) => vm.doEvent(EnableAutoValidateEvent()),
      expect: () => [
        isA<ChangePasswordState>().having(
          (s) => s.autoValidate,
          'autoValidate',
          true,
        ),
      ],
    );
  });

  group('ChangePasswordRequestEvent', () {
    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'emits loading then success on success',
      setUp: () {
        when(
          mockUseCase.changePassword(
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));
      },
      build: () => viewModel,
      act: (vm) => vm.doEvent(
        ChangePasswordRequestEvent(
          password: 'OldPass@123',
          newPassword: 'NewPass@123',
        ),
      ),
      expect: () => [
        isA<ChangePasswordState>().having(
          (s) => s.changePasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ChangePasswordState>()
            .having((s) => s.changePasswordState.isLoading, 'isLoading', false)
            .having((s) => s.changePasswordState.data, 'data', tEntity),
      ],
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'emits loading then error on failure',
      setUp: () {
        when(
          mockUseCase.changePassword(
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
      },
      build: () => viewModel,
      act: (vm) => vm.doEvent(
        ChangePasswordRequestEvent(
          password: 'OldPass@123',
          newPassword: 'NewPass@123',
        ),
      ),
      expect: () => [
        isA<ChangePasswordState>().having(
          (s) => s.changePasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ChangePasswordState>()
            .having((s) => s.changePasswordState.isLoading, 'isLoading', false)
            .having((s) => s.changePasswordState.data, 'data', null)
            .having((s) => s.changePasswordState.msg, 'msg', isNotNull),
      ],
    );
  });
}
