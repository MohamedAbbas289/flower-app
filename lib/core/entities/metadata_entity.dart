import 'package:equatable/equatable.dart';

class MetadataEntity extends Equatable {
  final int currentPage;
  final int totalPages;
  final int limit;

  const MetadataEntity({
    required this.currentPage,
    required this.totalPages,
    required this.limit,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, limit];
}
