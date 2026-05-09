class CategoryModel {
  String? id;
  String? name;
  String? slug;
  String? image;
  bool? isSuperAdmin;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? productsCount;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });
}