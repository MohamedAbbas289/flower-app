import 'package:flower_app/features/orders/api/data_sources/orders_remote_data_source_impl.dart';
import 'package:flower_app/features/orders/api/orders_api_client/orders_api_client.dart';
import 'package:flower_app/features/orders/api/responses/orders_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'orders_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OrdersApiClient])
void main() {
  late MockOrdersApiClient mockApiClient;
  late OrdersRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockOrdersApiClient();
    dataSource = OrdersRemoteDataSourceImpl(mockApiClient);
  });

  group('OrdersRemoteDataSourceImpl', () {
    test('getOrders returns OrdersResponse when api call succeeds', () async {
      const response = OrdersResponse(message: 'Success');

      when(mockApiClient.getOrders()).thenAnswer((_) async => response);

      final result = await dataSource.getOrders();

      expect(result, response);
      verify(mockApiClient.getOrders()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('getOrders propagates exception when api throws', () async {
      when(mockApiClient.getOrders()).thenThrow(Exception('network error'));

      expect(() => dataSource.getOrders(), throwsException);
      verify(mockApiClient.getOrders()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
