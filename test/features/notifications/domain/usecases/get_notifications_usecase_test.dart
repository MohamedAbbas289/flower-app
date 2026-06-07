import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';
import 'package:flower_app/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:flower_app/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_notifications_usecase_test.mocks.dart';

@GenerateMocks([NotificationsRepository])
void main() {
  late MockNotificationsRepository mockNotificationsRepository;
  late GetNotificationsUseCase getNotificationsUseCase;

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
    mockNotificationsRepository = MockNotificationsRepository();
    getNotificationsUseCase = GetNotificationsUseCase(
      mockNotificationsRepository,
    );
  });

  group('GetNotificationsUseCase', () {
    test(
      'should return SuccessBaseResponse<NotificationsResponseEntity> when repository succeeds',
      () async {
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
          mockNotificationsRepository.getUserNotifications(),
        ).thenAnswer((_) async => successResponse);

        final result = await getNotificationsUseCase.execute();

        expect(result, isA<SuccessBaseResponse<NotificationsResponseEntity>>());
        verify(mockNotificationsRepository.getUserNotifications()).called(1);
        verifyNoMoreInteractions(mockNotificationsRepository);
      },
    );

    test(
      'should return ErrorBaseResponse<NotificationsResponseEntity> when repository fails',
      () async {
        final exception = Exception("network error");
        final errorResponse = ErrorBaseResponse<NotificationsResponseEntity>(
          exception: exception,
        );

        when(
          mockNotificationsRepository.getUserNotifications(),
        ).thenAnswer((_) async => errorResponse);

        final result = await getNotificationsUseCase.execute();

        expect(result, isA<ErrorBaseResponse<NotificationsResponseEntity>>());
        final error = result as ErrorBaseResponse<NotificationsResponseEntity>;
        expect(error.exception, exception);
        verify(mockNotificationsRepository.getUserNotifications()).called(1);
        verifyNoMoreInteractions(mockNotificationsRepository);
      },
    );
  });
}
