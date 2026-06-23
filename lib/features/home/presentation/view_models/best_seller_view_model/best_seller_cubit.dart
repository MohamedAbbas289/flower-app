import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';
import 'package:flower_app/features/best_seller/domain/use_case/fetch_best_seller_use_case.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_event.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BestSellerCubit extends Cubit<BestSellerState> {
  final FetchBestSellerUseCase fetchBestSellerUseCase;

  BestSellerCubit({required this.fetchBestSellerUseCase})
    : super(BestSellerState());

  void doEvent(BestSellerEvent event) {
    switch (event) {
      case FetchBestSellerProductsEvent():
        _fetchBestSellerProducts();
        break;
      case RefreshBestSellerEvent():
        _fetchBestSellerProducts();
        break;
    }
  }

  Future<void> _fetchBestSellerProducts() async {
    emit(state.copyWith(bestSellerState: BaseState.loading()));
    final response = await fetchBestSellerUseCase.call();
    switch (response) {
      case SuccessBaseResponse<List<BestSellerProductEntity>>():
        emit(state.copyWith(bestSellerState: BaseState.success(response.data)));
        break;
      case ErrorBaseResponse<List<BestSellerProductEntity>>():
        emit(
          state.copyWith(
            bestSellerState: BaseState.error(response.errorMessage),
          ),
        );
        break;
    }
  }
}
