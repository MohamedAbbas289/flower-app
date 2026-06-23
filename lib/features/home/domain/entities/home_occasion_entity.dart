import 'package:equatable/equatable.dart';

class HomeOccasionEntity extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final int? productsCount;

  const HomeOccasionEntity({
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
