class Brand {
  final int id;
  final String name;
  final String logoUrl;

  Brand({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  // Factory untuk mengubah JSON dari Laravel menjadi Object Dart
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      logoUrl: json['logo_url'] ?? '', 
    );
  }
}