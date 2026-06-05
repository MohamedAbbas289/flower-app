import 'package:equatable/equatable.dart';

class CartProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imgCover;
  final int price;

  const CartProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imgCover,
    required this.price,
  });

  @override
  List<Object?> get props => [id, title, description, imgCover, price];
}