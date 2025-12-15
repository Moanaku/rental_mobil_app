class VehicleModel {
  final String name;
  final String imageAsset;
  final String cc;
  final String transmission;
  final String price;
  final double rating;
  final String type;

  VehicleModel({
    required this.name,
    required this.imageAsset,
    required this.cc,
    required this.transmission,
    required this.price,
    this.rating = 4.8,
    required this.type,
  });
}

// DATA DUMMY STABIL (Source: Unsplash)
// Gambar ini tidak akan error 403/404
final List<VehicleModel> dummyVehicles = [
  // --- HONDA ---
  VehicleModel(
    name: "Honda Brio",
    // Gambar mobil kecil kuning/hijau stabil
    imageAsset:
        "https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=600&q=80",
    cc: "1200Cc",
    transmission: "Matic",
    price: "Rp.100.000",
    type: "Mobil",
  ),
  VehicleModel(
    name: "Honda City",
    // Gambar sedan putih
    imageAsset:
        "https://images.unsplash.com/photo-1619682817481-e994891cd1f5?auto=format&fit=crop&w=600&q=80",
    cc: "1500Cc",
    transmission: "Matic",
    price: "Rp.250.000",
    type: "Mobil",
  ),
  VehicleModel(
    name: "Honda CBR 250Rr",
    // Gambar motor sport
    imageAsset:
        "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=600&q=80",
    cc: "250Cc",
    transmission: "Manual",
    price: "Rp.150.000",
    type: "Motor",
  ),

  // --- MITSUBISHI ---
  VehicleModel(
    name: "Mitsubishi Pajero Dakar",
    // Gambar SUV Offroad
    imageAsset:
        "https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?auto=format&fit=crop&w=600&q=80",
    cc: "2400Cc",
    transmission: "Matic",
    price: "Rp.500.000",
    type: "Mobil",
  ),
  VehicleModel(
    name: "Mitsubishi Xpander",
    // Gambar MPV Modern
    imageAsset:
        "https://images.unsplash.com/photo-1617788138017-80ad40651399?auto=format&fit=crop&w=600&q=80",
    cc: "1500Cc",
    transmission: "Matic",
    price: "Rp.300.000",
    type: "Mobil",
  ),

  // --- SUZUKI ---
  VehicleModel(
    name: "Suzuki Ertiga",
    // Gambar Mobil Keluarga
    imageAsset:
        "https://images.unsplash.com/photo-1609521263047-f8f205293f24?auto=format&fit=crop&w=600&q=80",
    cc: "1500Cc",
    transmission: "Manual",
    price: "Rp.150.000",
    type: "Mobil",
  ),
  VehicleModel(
    name: "Suzuki GSX-R150",
    // Gambar Motor Sport Biru
    imageAsset:
        "https://images.unsplash.com/photo-1599819811279-d5ad9cccf838?auto=format&fit=crop&w=600&q=80",
    cc: "150Cc",
    transmission: "Manual",
    price: "Rp.90.000",
    type: "Motor",
  ),

  // --- TOYOTA ---
  VehicleModel(
    name: "Toyota Avanza",
    // Gambar MPV Putih
    imageAsset:
        "https://images.unsplash.com/photo-1503376763036-066120622c74?auto=format&fit=crop&w=600&q=80",
    cc: "1300Cc",
    transmission: "Manual",
    price: "Rp.200.000",
    type: "Mobil",
  ),
  VehicleModel(
    name: "Toyota Fortuner",
    // Gambar SUV Putih
    imageAsset:
        "https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=600&q=80",
    cc: "2400Cc",
    transmission: "Matic",
    price: "Rp.600.000",
    type: "Mobil",
  ),

  // --- YAMAHA ---
  VehicleModel(
    name: "Yamaha NMAX",
    // Gambar Scooter Matic
    imageAsset:
        "https://images.unsplash.com/photo-1609630875171-b1321377ee53?auto=format&fit=crop&w=600&q=80",
    cc: "155Cc",
    transmission: "Matic",
    price: "Rp.120.000",
    type: "Motor",
  ),
];
