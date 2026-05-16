import 'package:equatable/equatable.dart';

class OccasionEntity extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final int? productsCount;

  const OccasionEntity({
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
