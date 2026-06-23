import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_entity.dart';
import 'package:flower_app/features/orders/domain/repository/orders_repository.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_orders_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepository])
void main() {
  late MockOrdersRepository mockRepository;
  late GetOrdersUseCase getOrdersUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<OrderEntity>>>(
      SuccessBaseResponse<List<OrderEntity>>(data: const []),
    );
  });

  setUp(() {
    mockRepository = MockOrdersRepository();
    getOrdersUseCase = GetOrdersUseCase(mockRepository);
  });

  group('GetOrdersUseCase', () {
    test(
      'execute returns SuccessBaseResponse<List<OrderEntity>> when repository succeeds',
      () async {
        final successResponse = SuccessBaseResponse<List<OrderEntity>>(
          data: const [
            OrderEntity(id: 'order1', orderNumber: '#123456', totalPrice: 600),
          ],
        );

        when(
          mockRepository.getOrders(),
        ).thenAnswer((_) async => successResponse);

        final result = await getOrdersUseCase.execute();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        final success = result as SuccessBaseResponse<List<OrderEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, 'order1');
        expect(success.data.first.orderNumber, '#123456');
        verify(mockRepository.getOrders()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'execute returns ErrorBaseResponse<List<OrderEntity>> when repository fails',
      () async {
        final exception = Exception('network error');
        final errorResponse = ErrorBaseResponse<List<OrderEntity>>(
          exception: exception,
        );

        when(mockRepository.getOrders()).thenAnswer((_) async => errorResponse);

        final result = await getOrdersUseCase.execute();

        expect(result, isA<ErrorBaseResponse<List<OrderEntity>>>());
        final error = result as ErrorBaseResponse<List<OrderEntity>>;
        expect(error.exception, exception);
        verify(mockRepository.getOrders()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
