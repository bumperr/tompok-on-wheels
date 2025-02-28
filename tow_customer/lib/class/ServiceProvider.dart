class ServiceProvider {
  final String id;
  final String name;
  final String category;
  final String logoUrl;
  final bool isVerified;
  final double? rating;
  final double? distance;
  final int? travelTime;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.category,
    required this.logoUrl,
    required this.isVerified,
    this.rating,
    this.distance,
    this.travelTime,
  });
}