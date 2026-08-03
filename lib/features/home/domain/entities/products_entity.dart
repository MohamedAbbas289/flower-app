import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/product_card_data.dart';

class ProductsEntity extends Equatable {
  final List<ProductEntity> products;
  final int totalPages;
  final int currentPage;

  const ProductsEntity({
    required this.products,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [products, totalPages, currentPage];
}

class ProductEntity extends Equatable implements ProductCardData {
  @override
  final String id;

  @override
  final String name;

  @override
  final String imageUrl;

  @override
  final int price;

  @override
  final int? originalPrice;

  @override
  final int? discountPercent;

  @override
  int? get availableQuantity => null;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        price,
        originalPrice,
        discountPercent,
      ];
}
