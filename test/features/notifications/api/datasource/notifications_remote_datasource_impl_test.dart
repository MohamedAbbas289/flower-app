import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/api/api_client/notifications_api_client.dart';
import 'package:flower_app/features/notifications/api/datasource/notifications_remote_datasource_impl.dart';
import 'package:flower_app/features/notifications/data/models/notifications_response.dart'; // اسم الموديل المتوقع عندك
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'notifications_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([NotificationsApiClient])
void main() {
  late MockNotificationsApiClient mockNotificationsApiClient;
  late NotificationsRemoteDatasourceImpl notificationsRemoteDatasourceImpl;

  setUp(() {
    mockNotificationsApiClient = MockNotificationsApiClient();
    notificationsRemoteDatasourceImpl = NotificationsRemoteDatasourceImpl(
      mockNotificationsApiClient,
    );
  });

  group('NotificationsRemoteDatasourceImpl', () {
    test('should return SuccessBaseResponse when api call succeeds', () async {
      final response = NotificationsResponse(notifications: []);

      when(
        mockNotificationsApiClient.getUserNotifications(),
      ).thenAnswer((_) async => response);

      final result = await notificationsRemoteDatasourceImpl
          .getUserNotifications();

      expect(result, isA<SuccessBaseResponse<NotificationsResponse>>());
      expect(
        (result as SuccessBaseResponse<NotificationsResponse>).data,
        response,
      );
      verify(mockNotificationsApiClient.getUserNotifications()).called(1);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('network error');

      when(
        mockNotificationsApiClient.getUserNotifications(),
      ).thenThrow(exception);

      final result = await notificationsRemoteDatasourceImpl
          .getUserNotifications();

      expect(result, isA<ErrorBaseResponse<NotificationsResponse>>());
      expect((result as ErrorBaseResponse).exception, exception);
      verify(mockNotificationsApiClient.getUserNotifications()).called(1);
    });
  });
}
