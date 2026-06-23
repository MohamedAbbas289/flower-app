import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/tab_item_data.dart';

class OccasionsEntity extends Equatable {
  final List<OccasionEntity> occasions;
  final int totalPages;
  final int currentPage;
  const OccasionsEntity({
    required this.occasions,
    required this.totalPages,
    required this.currentPage,
  });
  @override
  List<Object?> get props => [occasions, totalPages, currentPage];
}

class OccasionEntity extends Equatable implements TabItemData {
  @override
  final String id;
  @override
  final String name;
  final int productsCount;

  const OccasionEntity({
    required this.id,
    required this.name,
    required this.productsCount,
  });

  @override
  List<Object?> get props => [id, name, productsCount];
}
