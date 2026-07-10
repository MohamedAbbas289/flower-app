import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/data/data_sources_contract/shopping_firestore_data_source_contract.dart';
import 'package:flower_app/features/shopping/data/data_sources_contract/shopping_remote_data_source_contract.dart';
import 'package:flower_app/features/shopping/data/models/cart_model.dart';
import 'package:flower_app/features/shopping/data/models/cart_response_model.dart';
import 'package:flower_app/features/shopping/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/shopping/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/shopping/data/models/order_model.dart';
import 'package:flower_app/features/shopping/data/models/orders_response.dart';
import 'package:flower_app/features/shopping/data/models/product_details_response.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/shopping/domain/mappers/payment_mapper.dart';
import 'package:flower_app/features/shopping/domain/mappers/product_details_mapper.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ShoppingRepositoryContract)
class ShoppingRepositoryImpl implements ShoppingRepositoryContract {
  final ShoppingRemoteDataSourceContract _dataSource;
  final ShoppingFirestoreDataSourceContract _firestoreDataSource;

  ShoppingRepositoryImpl(this._dataSource, this._firestoreDataSource);

  @override
  Future<BaseResponse<CartEntity>> getCart() async {
    final response = await _dataSource.getCart();
    return _mapCartResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> addToCart(
    CartRequestModel requestModel,
  ) async {
    final response = await _dataSource.addToCart(requestModel);
    return _mapCartResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> updateQuantity(
    CartRequestModel requestModel,
  ) async {
    final response = await _dataSource.updateQuantity(requestModel);
    return _mapCartResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> removeProductfromCart(
    String productId,
  ) async {
    final response = await _dataSource.removeProductfromCart(productId);
    return _mapCartResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> clearCart() async {
    final response = await _dataSource.clearCart();
    return _mapCartResponse(response);
  }

  BaseResponse<CartEntity> _mapCartResponse(
    BaseResponse<CartResponseModel> response,
  ) {
    switch (response) {
      case SuccessBaseResponse<CartResponseModel>():
        return SuccessBaseResponse(
          data:
              response.data.cart?.toEntity() ??
              const CartEntity(
                id: '',
                cartItems: [],
                totalPrice: 0,
                totalPriceAfterDiscount: 0,
                discount: 0,
                numOfCartItems: 0,
              ),
        );
      case ErrorBaseResponse<CartResponseModel>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Future<BaseResponse<List<OrderEntity>>> getOrders() async {
    final response = await _dataSource.getOrders();
    return switch (response) {
      SuccessBaseResponse<OrdersResponse>() => SuccessBaseResponse(
        data:
            response.data.orders?.map((e) => e.toEntity()).toList() ??
            <OrderEntity>[],
      ),
      ErrorBaseResponse<OrdersResponse>() => ErrorBaseResponse(
        exception: response.exception,
      ),
    };
  }

  @override
  Future<BaseResponse<CashOrderEntity>> createCashOrder(
    PaymentRequestModel requestModel,
  ) async {
    final response = await _dataSource.createCashOrder(requestModel);
    return switch (response) {
      SuccessBaseResponse<CashOrderResponseModel>() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse<CashOrderResponseModel>() => ErrorBaseResponse(
        exception: response.exception,
      ),
    };
  }

  @override
  Future<BaseResponse<CheckoutSessionEntity>> createCheckoutSession(
    PaymentRequestModel requestModel,
  ) async {
    final response = await _dataSource.createCheckoutSession(requestModel);
    return switch (response) {
      SuccessBaseResponse<CheckoutSessionResponseModel>() =>
        SuccessBaseResponse(data: response.data.toEntity()),
      ErrorBaseResponse<CheckoutSessionResponseModel>() => ErrorBaseResponse(
        exception: response.exception,
      ),
    };
  }

  @override
  Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  }) async {
    final response = await _dataSource.getProductDetails(
      productId: productId,
    );

    switch (response) {
      case SuccessBaseResponse<ProductDetailsResponse>():
        final data = response.data.toEntity();
        return SuccessBaseResponse(data: data);
      case ErrorBaseResponse<ProductDetailsResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Stream<DocumentSnapshot> orderStream(String orderId) {
    return _firestoreDataSource.orderStream(orderId);
  }

  @override
  Future<void> confirmDelivery(String orderId) {
    return _firestoreDataSource.confirmDelivery(orderId);
  }
}
