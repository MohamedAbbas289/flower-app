import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String id;
  final String name;
  final String? governorateId;

  const LocationEntity({
    required this.id,
    required this.name,
    this.governorateId,
  });

  @override
  List<Object?> get props => [id, name, governorateId];
}
