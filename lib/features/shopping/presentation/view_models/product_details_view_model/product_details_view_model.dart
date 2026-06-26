import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/shopping/domain/use_cases/product_details_use_case.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_events.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsViewModel extends Cubit<ProductDetailsBaseState> {
  final ProductDetailsUseCase _productDetailsUseCase;

  ProductDetailsViewModel(this._productDetailsUseCase)
    : super(const ProductDetailsBaseState());

  void doEvent(ProductDetailsEvent event) {
    switch (event) {
      case GetProductDetailsEvent():
        _getProductDetails(event.productId);
    }
  }

  Future<void> _getProductDetails(String productId) async {
    if (isClosed) return;
    emit(state.copyWith(productDetailsState: BaseState.loading()));
    final response = await _productDetailsUseCase.execute(productId: productId);
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<ProductDetailsEntity>():
        emit(
          state.copyWith(
            productDetailsState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse<ProductDetailsEntity>():
        emit(
          state.copyWith(
            productDetailsState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }
}
