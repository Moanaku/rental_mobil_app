class TransactionModel {
  final int id;
  final String bookingCode;
  final int userId;
  final int vehicleId;
  
  // Data tambahan dari relasi Vehicle untuk UI (Nama & Gambar Mobil)
  final String vehicleName; 
  final String vehicleImage; 
  
  final String startDate;
  final String endDate;
  final double totalPrice;
  final String status; // 'pending', 'active', 'completed', 'cancelled'
  final String paymentMethod; // 'cash'

  TransactionModel({
    required this.id,
    required this.bookingCode,
    required this.userId,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImage,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      bookingCode: json['booking_code'] ?? '',
      userId: json['user_id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,
      
      // Mengambil data kendaraan dari nested object 'vehicle'
      vehicleName: json['vehicle'] != null ? (json['vehicle']['name'] ?? 'Kendaraan') : 'Kendaraan Tidak Ditemukan',
      vehicleImage: json['vehicle'] != null ? (json['vehicle']['image_url'] ?? '') : '',
      
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      
      // Konversi total_price ke double dengan aman
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'] ?? 'cash',
    );
  }
}