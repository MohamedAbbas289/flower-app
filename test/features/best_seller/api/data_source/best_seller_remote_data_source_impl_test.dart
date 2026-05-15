import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/api/api_client/best_seller_api_client.dart';
import 'package:flower_app/features/best_seller/api/data_source/best_seller_remote_data_source_impl.dart';
import 'package:flower_app/features/best_seller/data/model/best_seller_response.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'best_seller_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([BestSellerApiClient])
void main() {
  late MockBestSellerApiClient mockBestSellerApiClient;
  late BestSellerRemoteDataSourceImpl bestSellerRemoteDataSourceImpl;

  setUp(() {
    mockBestSellerApiClient = MockBestSellerApiClient();
    bestSellerRemoteDataSourceImpl = BestSellerRemoteDataSourceImpl(
      mockBestSellerApiClient,
    );
  });

  group('BestSellerRemoteDataSourceImpl', () {
    test('should return SuccessBaseResponse when api call succeeds', () async {
      // Arrange
      final bestSellerResponse =
          BestSellerResponse(); // أضف constructor parameters إذا لزم الأمر

      when(
        mockBestSellerApiClient.fetchBestSellers(),
      ).thenAnswer((_) async => bestSellerResponse);

      // Act
      final result = await bestSellerRemoteDataSourceImpl.fetchBestSellers();

      // Assert
      expect(result, isA<SuccessBaseResponse<BestSellerResponse>>());
      expect(
        (result as SuccessBaseResponse<BestSellerResponse>).data,
        bestSellerResponse,
      );
      verify(mockBestSellerApiClient.fetchBestSellers()).called(1);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      // Arrange
      final exception = Exception('network error');

      when(mockBestSellerApiClient.fetchBestSellers()).thenThrow(exception);

      // Act
      final result = await bestSellerRemoteDataSourceImpl.fetchBestSellers();

      // Assert
      expect(result, isA<ErrorBaseResponse<BestSellerResponse>>());
      expect(
        (result as ErrorBaseResponse<BestSellerResponse>).exception,
        exception,
      );
      verify(mockBestSellerApiClient.fetchBestSellers()).called(1);
    });
  });
}
