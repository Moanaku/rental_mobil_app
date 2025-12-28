import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../core/theme/app_pallete.dart';
import '../models/vehicle_model.dart';
import '../widgets/custom_button.dart';
import 'success_screen.dart';
import '../services/api_service.dart'; 

class PaymentScreen extends StatefulWidget {
  final Vehicle vehicle;

  const PaymentScreen({super.key, required this.vehicle});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // State untuk tanggal dan harga
  DateTime? _startDate;
  DateTime? _endDate;
  int rentalDays = 0;
  double totalPrice = 0;
  
  // Loading state untuk tombol
  bool _isProcessing = false;

  // Helper format rupiah
  String _formatCurrency(double price) {
    if (price == 0) return "Rp 0";
    try {
      String priceStr = price.toInt().toString();
      String result = '';
      int count = 0;
      for (int i = priceStr.length - 1; i >= 0; i--) {
        result = priceStr[i] + result;
        count++;
        if (count == 3 && i > 0) {
          result = '.$result';
          count = 0;
        }
      }
      return 'Rp $result';
    } catch (e) {
      return "Rp Error";
    }
  }

  // Fungsi Memunculkan Date Range Picker (Kalender Asli)
  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: now, 
      lastDate: DateTime(now.year + 1), 
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppPallete.primary,
            colorScheme: const ColorScheme.light(primary: AppPallete.primary),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        rentalDays = picked.duration.inDays + 1; 
        totalPrice = widget.vehicle.pricePerDay * rentalDays;
      });
    }
  }

  String get _dateRangeText {
    if (_startDate == null || _endDate == null) {
      return "Pilih Tanggal";
    }
    final start = "${_startDate!.day}/${_startDate!.month}";
    final end = "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}";
    return "$start - $end";
  }

  // [FUNGSI UTAMA] Kirim Data ke Laravel
  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true; // Tampilkan loading
    });

    final apiService = ApiService();
    
    // Format tanggal ke YYYY-MM-DD agar diterima MySQL Laravel
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startStr = formatter.format(_startDate!);
    final String endStr = formatter.format(_endDate!);

    bool success = await apiService.createTransaction(
      vehicleId: widget.vehicle.id,
      startDate: startStr,
      endDate: endStr,
      totalPrice: totalPrice,
      userId: 1, // [HARDCODE] Sementara ID User 1 (Admin/User Dummy)
    );

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      if (!mounted) return;
      // Jika Sukses -> Pindah ke Halaman Sukses
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } else {
      if (!mounted) return;
      // Jika Gagal -> Tampilkan Pesan Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal membuat pesanan. Coba lagi."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppPallete.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppPallete.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. KARTU RINGKASAN MOBIL
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPallete.border),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.vehicle.imageUrl,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vehicle.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${_formatCurrency(widget.vehicle.pricePerDay)}/hari",
                          style: const TextStyle(fontSize: 12, color: AppPallete.greyText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. DURASI SEWA (PILIH TANGGAL)
            const Text("Durasi Sewa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppPallete.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: AppPallete.primary, size: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tanggal Sewa", style: TextStyle(fontSize: 10, color: AppPallete.greyText)),
                        Text(
                          _dateRangeText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: AppPallete.greyText),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 3. METODE PEMBAYARAN
            const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppPallete.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.money, color: AppPallete.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text("Tunai", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. HARGA DETAIL
            const Text("Harga Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            
            _buildPriceRow("Periode Waktu", "$rentalDays Hari"),
            const SizedBox(height: 8),
            
            _buildPriceRow("Harga Satuan", _formatCurrency(widget.vehicle.pricePerDay)),
            const SizedBox(height: 8),

            _buildPriceRow("Subtotal", _formatCurrency(totalPrice)),
            
            const Divider(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  _formatCurrency(totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppPallete.primary, fontSize: 16),
                ),
              ],
            ),

            const Spacer(),

            // 5. TOMBOL KONFIRMASI
            // Tampilkan Loading jika sedang proses
            _isProcessing 
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
                  text: "Konfirmasi & Bayar",
                  onPressed: rentalDays == 0 ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Silakan pilih tanggal sewa terlebih dahulu")),
                    );
                  } : () {
                    // [AKSI] Panggil fungsi kirim ke server
                    _processPayment();
                  },
                ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppPallete.greyText)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}