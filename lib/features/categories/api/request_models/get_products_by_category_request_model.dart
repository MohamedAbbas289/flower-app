class GetProductsByCategoryRequestModel {
  final String? categoryId;
  final String? sort;
  final bool reverseResults;

  const GetProductsByCategoryRequestModel({
    this.categoryId,
    this.sort,
    this.reverseResults = false,
  });
}
