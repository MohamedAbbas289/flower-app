import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/data/datasource/notifications_remote_datasource.dart';
import 'package:flower_app/features/notifications/data/models/notifications_response.dart';
import 'package:flower_app/features/notifications/data/repositories/notifications_repo_impl.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'notifications_repo_impl_test.mocks.dart';

@GenerateMocks([NotificationsRemoteDatasource])
void main() {
  late MockNotificationsRemoteDatasource mockRemoteDatasource;
  late NotificationsRepositoryImpl notificationsRepositoryImpl;

  setUpAll(() {
    provideDummy<BaseResponse<NotificationsResponse>>(
      SuccessBaseResponse<NotificationsResponse>(
        data: NotificationsResponse(notifications: []),
      ),
    );
  });

  setUp(() {
    mockRemoteDatasource = MockNotificationsRemoteDatasource();
    notificationsRepositoryImpl = NotificationsRepositoryImpl(
      mockRemoteDatasource,
    );
  });

  group('NotificationsRepositoryImpl', () {
    test(
      'should return SuccessBaseResponse<NotificationsResponseEntity> when datasource succeeds',
      () async {
        final remoteResponse = NotificationsResponse(notifications: []);
        final successResponse = SuccessBaseResponse<NotificationsResponse>(
          data: remoteResponse,
        );

        when(
          mockRemoteDatasource.getUserNotifications(),
        ).thenAnswer((_) async => successResponse);

        final result = await notificationsRepositoryImpl.getUserNotifications();

        expect(result, isA<SuccessBaseResponse<NotificationsResponseEntity>>());
        verify(mockRemoteDatasource.getUserNotifications()).called(1);
        verifyNoMoreInteractions(mockRemoteDatasource);
      },
    );

    test(
      'should return ErrorBaseResponse<NotificationsResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');
        final errorResponse = ErrorBaseResponse<NotificationsResponse>(
          exception: exception,
        );

        when(
          mockRemoteDatasource.getUserNotifications(),
        ).thenAnswer((_) async => errorResponse);

        final result = await notificationsRepositoryImpl.getUserNotifications();

        expect(result, isA<ErrorBaseResponse<NotificationsResponseEntity>>());
        final error = result as ErrorBaseResponse<NotificationsResponseEntity>;
        expect(error.exception, exception);
        verify(mockRemoteDatasource.getUserNotifications()).called(1);
        verifyNoMoreInteractions(mockRemoteDatasource);
      },
    );
  });
}
