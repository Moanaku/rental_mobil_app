class Vehicle {
  final int id;
  final String name;
  final int brandId; 
  final String brandName; 
  final String brandLogo; 
  final String imageUrl;
  final String description;
  final double pricePerDay;
  final String category; 
  final String transmission; 
  final String fuel; 
  final int seats;
  final bool isAvailable;
  final String engineCapacity;

  Vehicle({
    required this.id,
    required this.name,
    required this.brandId,
    required this.brandName,
    required this.brandLogo,
    required this.imageUrl,
    required this.description,
    required this.pricePerDay,
    required this.category,
    required this.transmission,
    required this.fuel,
    required this.seats,
    required this.isAvailable,
    required this.engineCapacity,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tanpa Nama',
      
      // Mengambil data nested (bersarang) dari relasi brand
      // Logika: Coba ambil dari object 'brand', kalau null coba ambil langsung 'brand_id'
      brandId: json['brand']?['id'] ?? json['brand_id'] ?? 0,
      brandName: json['brand']?['name'] ?? json['brand_name'] ?? 'Unknown Brand',
      
      // Pastikan URL gambar sudah full path dari Laravel (asset/storage)
      brandLogo: json['brand']?['logo_url'] ?? json['brand_logo'] ?? '',

      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? 'Tidak ada deskripsi',
      
      // Konversi Harga ke Double agar aman
      pricePerDay: double.tryParse(json['price_per_day'].toString()) ?? 0.0,
      
      category: json['category'] ?? '-',
      transmission: json['transmission'] ?? '-',
      fuel: json['fuel'] ?? '-',
      
      seats: int.tryParse(json['seats'].toString()) ?? 0,
      
      // Status boolean: Handle jika API kirim 1/0 atau true/false
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      
      engineCapacity: json['engine_capacity'] ?? '-',
    );
  }
}