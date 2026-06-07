import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';
import 'package:flower_app/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_events.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'notifications_cubit_test.mocks.dart';

@GenerateMocks([GetNotificationsUseCase])
void main() {
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late NotificationsViewModel viewModel;

  setUpAll(() {
    provideDummy<BaseResponse<NotificationsResponseEntity>>(
      SuccessBaseResponse<NotificationsResponseEntity>(
        data: const NotificationsResponseEntity(
          notifications: [],
          message: '',
          metadata: MetadataEntity(
            currentPage: 1,
            totalPages: 1,
            limit: 10,
            totalItems: 0,
            unreadCount: 0,
          ),
        ),
      ),
    );
  });

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    viewModel = NotificationsViewModel(mockGetNotificationsUseCase);
  });

  group('NotificationsViewModel', () {
    test('initial state should be const NotificationsState()', () {
      expect(viewModel.state, equals(const NotificationsState()));
    });

    blocTest<NotificationsViewModel, NotificationsState>(
      'should emit loading then success when fetching notifications succeeds',
      build: () {
        final successResponse =
            SuccessBaseResponse<NotificationsResponseEntity>(
              data: const NotificationsResponseEntity(
                notifications: [],
                message: 'Success',
                metadata: MetadataEntity(
                  currentPage: 1,
                  totalPages: 1,
                  limit: 10,
                  totalItems: 0,
                  unreadCount: 0,
                ),
              ),
            );

        when(
          mockGetNotificationsUseCase.execute(),
        ).thenAnswer((_) async => successResponse);

        return viewModel;
      },
      act: (cubit) {
        cubit.doEvent(GetNotificationsEvent());
      },
      expect: () => [
        NotificationsState(notificationsState: BaseState.loading()),
        NotificationsState(
          notificationsState: BaseState.success(
            const NotificationsResponseEntity(
              notifications: [],
              message: 'Success',
              metadata: MetadataEntity(
                currentPage: 1,
                totalPages: 1,
                limit: 10,
                totalItems: 0,
                unreadCount: 0,
              ),
            ),
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetNotificationsUseCase.execute()).called(1);
        verifyNoMoreInteractions(mockGetNotificationsUseCase);
      },
    );

    blocTest<NotificationsViewModel, NotificationsState>(
      'should emit loading then error when fetching notifications fails',
      build: () {
        final errorResponse = ErrorBaseResponse<NotificationsResponseEntity>(
          exception: Exception('network error'),
        );

        when(
          mockGetNotificationsUseCase.execute(),
        ).thenAnswer((_) async => errorResponse);

        return viewModel;
      },
      act: (cubit) {
        cubit.doEvent(GetNotificationsEvent());
      },
      expect: () => [
        NotificationsState(notificationsState: BaseState.loading()),
        NotificationsState(
          notificationsState: BaseState.error(
            'somethingWentWrong', //  عدلنا دي لتطابق الـ Key الفعلي اللي طالع من الـ ViewModel
          ),
        ),
      ],
    );
  });
}
