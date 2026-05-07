import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/states/forget_password_states.dart';
import 'package:test/test.dart';

void main() {
  final entity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
    message: "Success",
  );

  group("ForgetPasswordState", () {
    test("default state values", () {
      const state = ForgetPasswordState();

      expect(state.isLoading, false);
      expect(state.data, isNull);
      expect(state.error, isNull);
    });

    group("copyWith - loading", () {
      test("set loading true", () {
        const state = ForgetPasswordState();

        final updated = state.copyWith(isLoading: true);

        expect(updated.isLoading, true);
      });
    });

    group("copyWith - data", () {
      test("set data", () {
        const state = ForgetPasswordState();

        final updated = state.copyWith(data: entity);

        expect(updated.data?.message, entity.message);
      });

      test("clear data", () {
        final state = ForgetPasswordState(data: entity);

        final updated = state.copyWith(clearData: true);

        expect(updated.data, isNull);
      });
    });

    group("copyWith - error", () {
      test("set error", () {
        const state = ForgetPasswordState();

        final updated = state.copyWith(error: "Error");

        expect(updated.error, "Error");
      });

      test("clear error", () {
        final state = ForgetPasswordState(error: "Error");

        final updated = state.copyWith(clearError: true);

        expect(updated.error, isNull);
      });
    });

    group("combined behavior", () {
      test("multiple updates", () {
        final updated = const ForgetPasswordState().copyWith(
          isLoading: true,
          data: entity,
          error: "error",
        );

        expect(updated.isLoading, true);
        expect(updated.data, isNotNull);
        expect(updated.error, "error");
      });
    });
  });
}
