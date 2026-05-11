import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final String? name;
  final String? slug;
  final String? image;
  final bool? isSuperAdmin;
  final String? createdAt;
  final String? updatedAt;
  final num? productsCount;

  const CategoryEntity({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    image,
    isSuperAdmin,
    createdAt,
    updatedAt,
    productsCount,
  ];
}
