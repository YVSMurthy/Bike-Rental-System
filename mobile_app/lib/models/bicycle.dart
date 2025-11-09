class Bicycle {
  final String id;
  final String model;
  final String? color;
  final String? assetCode;
  final String status;
  final String? locality;

  Bicycle({
    required this.id,
    required this.model,
    required this.status,
    this.color,
    this.assetCode,
    this.locality,
  });
}