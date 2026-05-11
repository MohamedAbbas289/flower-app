import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/product_details/domain/use_case/product_details_use_case.dart';
import 'package:flower_app/features/product_details/presentation/view_model/product_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsBaseState> {
  final ProductDetailsUseCase _productDetailsUseCase;

  ProductDetailsCubit(this._productDetailsUseCase)
    : super(const ProductDetailsInitial());

  // TODO: Add productId parameter when Feature/best-sellers is implemented
  Future<void> getProductDetails() async {
    emit(const ProductDetailsLoading());

    final result = await _productDetailsUseCase.getProductDetails();

    switch (result) {
      case SuccessBaseResponse<ProductDetailsEntity>():
        emit(ProductDetailsSuccess(result.data));
      case ErrorBaseResponse<ProductDetailsEntity>():
        emit(ProductDetailsFailure(_extractErrorMessage(result)));
    }
  }

  String _extractErrorMessage(
    ErrorBaseResponse<ProductDetailsEntity> response,
  ) {
    if (response.errorMessage.isNotEmpty) return response.errorMessage;
    return AppStrings.somethingWentWrong;
  }
}
