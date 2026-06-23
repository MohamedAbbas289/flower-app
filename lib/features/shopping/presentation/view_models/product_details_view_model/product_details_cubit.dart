import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/shopping/domain/use_cases/product_details_use_case.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_events.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsBaseState> {
  final ProductDetailsUseCase _productDetailsUseCase;

  ProductDetailsCubit(this._productDetailsUseCase)
    : super(const ProductDetailsBaseState());

  void doEvent(ProductDetailsEvent event) {
    switch (event) {
      case GetProductDetailsEvent():
        _getProductDetails(event.productId);
        break;
    }
  }

  Future<void> _getProductDetails(String productId) async {
    emit(state.copyWith(productDetailsState: BaseState.loading()));
    final response = await _productDetailsUseCase.getProductDetails(
      productId: productId,
    );

    switch (response) {
      case SuccessBaseResponse<ProductDetailsEntity>():
        emit(
          state.copyWith(productDetailsState: BaseState.success(response.data)),
        );
        break;
      case ErrorBaseResponse<ProductDetailsEntity>():
        emit(
          state.copyWith(
            productDetailsState: BaseState.error(response.errorMessage),
          ),
        );
        break;
    }
  }
}
