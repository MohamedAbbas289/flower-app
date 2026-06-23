import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/home/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_entity.dart';

class OccasionsState extends Equatable {
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<List<ProductEntity>> productsState;
  final String? selectedOccasionId;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final int paginationResetKey;
  final int occasionsCurrentPage;
  final int occasionsTotalPages;
  final bool isLoadingMoreOccasions;

  const OccasionsState({
    this.occasionsState = const BaseState(),
    this.productsState = const BaseState(),
    this.selectedOccasionId,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.paginationResetKey = 0,
    this.occasionsCurrentPage = 1,
    this.occasionsTotalPages = 1,
    this.isLoadingMoreOccasions = false,
  });

  OccasionsState copyWith({
    BaseState<List<OccasionEntity>>? occasionsState,
    BaseState<List<ProductEntity>>? productsState,
    String? selectedOccasionId,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPages,
    int? paginationResetKey,
    int? occasionsCurrentPage,
    int? occasionsTotalPages,
    bool? isLoadingMoreOccasions,
  }) {
    return OccasionsState(
      occasionsState: occasionsState ?? this.occasionsState,
      productsState: productsState ?? this.productsState,
      selectedOccasionId: selectedOccasionId ?? this.selectedOccasionId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      paginationResetKey: paginationResetKey ?? this.paginationResetKey,
      occasionsCurrentPage: occasionsCurrentPage ?? this.occasionsCurrentPage,
      occasionsTotalPages: occasionsTotalPages ?? this.occasionsTotalPages,
      isLoadingMoreOccasions:
          isLoadingMoreOccasions ?? this.isLoadingMoreOccasions,
    );
  }

  @override
  List<Object?> get props => [
    occasionsState,
    productsState,
    selectedOccasionId,
    isLoadingMore,
    currentPage,
    totalPages,
    paginationResetKey,
    occasionsCurrentPage,
    occasionsTotalPages,
    isLoadingMoreOccasions,
  ];
}
