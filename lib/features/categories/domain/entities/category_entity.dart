import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/tab_item_data.dart';

class CategoryEntity extends Equatable implements TabItemData {
  final String? rawId;
  final String? rawName;
  final String? slug;
  final String? image;
  final bool? isSuperAdmin;
  final String? createdAt;
  final String? updatedAt;
  final num? productsCount;

  const CategoryEntity({
    String? id,
    String? name,
    this.slug,
    this.image,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  }) : rawId = id,
       rawName = name;

  // TabItem implementation
  @override
  String get id => rawId ?? '';

  @override
  String get name => rawName ?? '';

  @override
  List<Object?> get props => [
    rawId,
    rawName,
    slug,
    image,
    isSuperAdmin,
    createdAt,
    updatedAt,
    productsCount,
  ];
}
