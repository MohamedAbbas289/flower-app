class LocationEntity {
  final String id;
  final String name;
  final String? governorateId;

  const LocationEntity({
    required this.id,
    required this.name,
    this.governorateId,
  });
}