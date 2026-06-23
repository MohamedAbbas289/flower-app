import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/metadata_entity.dart';
import 'package:flower_app/features/home/domain/entities/category_entity.dart';

class CategoriesResponseEntity extends Equatable {
  final List<CategoryEntity> categories;
  final MetadataEntity? metadata;

  const CategoriesResponseEntity({required this.categories, this.metadata});

  @override
  List<Object?> get props => [categories, metadata];
}
