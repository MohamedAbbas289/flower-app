import 'package:equatable/equatable.dart';

class HomeCategoryEntity extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final int? productsCount;

  const HomeCategoryEntity({
    this.id,
    this.name,
    this.image,
    this.productsCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    productsCount,
  ];
}
