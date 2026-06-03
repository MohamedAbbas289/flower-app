import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/auth/logout/domain/use_cases/logout_use_case.dart';
import 'package:flower_app/features/auth/logout/presentation/view_model/logout_events.dart';
import 'package:flower_app/features/auth/logout/presentation/view_model/logout_state.dart';
import 'package:flower_app/features/auth/logout/presentation/view_model/logout_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late MockLogoutUseCase logoutUseCase;

  setUp(() {
    logoutUseCase = MockLogoutUseCase();
  });

  LogoutViewModel buildViewModel() => LogoutViewModel(logoutUseCase);

  group('LogoutViewModel', () {
    test('initial state is LogoutState with default BaseState', () {
      expect(buildViewModel().state, const LogoutState());
    });

    blocTest<LogoutViewModel, LogoutState>(
      'emits loading then success when logout succeeds',
      build: buildViewModel,
      setUp: () {
        when(
          () => logoutUseCase.execute(),
        ).thenAnswer((_) async => SuccessBaseResponse<void>(data: null));
      },
      act: (vm) => vm.doEvent(LogoutRequestEvent()),
      expect: () => [
        isA<LogoutState>().having(
          (s) => s.logoutState.isLoading,
          'isLoading',
          true,
        ),
        isA<LogoutState>()
            .having((s) => s.logoutState.isLoading, 'isLoading', false)
            .having((s) => s.logoutState.msg, 'msg', isNull),
      ],
    );

    blocTest<LogoutViewModel, LogoutState>(
      'emits loading then error when logout API fails',
      build: buildViewModel,
      setUp: () {
        when(() => logoutUseCase.execute()).thenAnswer(
          (_) async =>
              ErrorBaseResponse<void>(exception: Exception('Server error')),
        );
      },
      act: (vm) => vm.doEvent(LogoutRequestEvent()),
      expect: () => [
        isA<LogoutState>().having(
          (s) => s.logoutState.isLoading,
          'isLoading',
          true,
        ),
        isA<LogoutState>()
            .having((s) => s.logoutState.isLoading, 'isLoading', false)
            .having((s) => s.logoutState.msg, 'msg', isNotNull),
      ],
    );

    blocTest<LogoutViewModel, LogoutState>(
      'calls LogoutUseCase.execute() exactly once',
      build: buildViewModel,
      setUp: () {
        when(
          () => logoutUseCase.execute(),
        ).thenAnswer((_) async => SuccessBaseResponse<void>(data: null));
      },
      act: (vm) => vm.doEvent(LogoutRequestEvent()),
      verify: (_) {
        verify(() => logoutUseCase.execute()).called(1);
      },
    );

    blocTest<LogoutViewModel, LogoutState>(
      'success state has null msg and null data (void)',
      build: buildViewModel,
      setUp: () {
        when(
          () => logoutUseCase.execute(),
        ).thenAnswer((_) async => SuccessBaseResponse<void>(data: null));
      },
      act: (vm) => vm.doEvent(LogoutRequestEvent()),
      verify: (vm) {
        expect(vm.state.logoutState.msg, isNull);
        expect(vm.state.logoutState.isLoading, isFalse);
      },
    );

    blocTest<LogoutViewModel, LogoutState>(
      'error state has non-null msg and is not loading',
      build: buildViewModel,
      setUp: () {
        when(() => logoutUseCase.execute()).thenAnswer(
          (_) async =>
              ErrorBaseResponse<void>(exception: Exception('Unauthorized')),
        );
      },
      act: (vm) => vm.doEvent(LogoutRequestEvent()),
      verify: (vm) {
        expect(vm.state.logoutState.msg, isNotNull);
        expect(vm.state.logoutState.isLoading, isFalse);
      },
    );
  });
}
