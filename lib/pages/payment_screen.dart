import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../models/vehicle_model.dart';
import '../widgets/custom_button.dart';
import 'success_screen.dart'; // Kita akan buat ini di langkah 3

class PaymentScreen extends StatefulWidget {
  final VehicleModel vehicle;

  const PaymentScreen({super.key, required this.vehicle});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Simulasi tanggal yang dipilih
  String selectedDateRange = "Pilih Tanggal";

  // Fungsi untuk Memunculkan Kalender (Set Jadwal)
  void _showCalendarModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: 600,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, color: Colors.grey[300]),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  "Pilih Tanggal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              
              // Simulasi Kalender (Sesuai gambar image_097205.png)
              _buildDummyCalendar(),

              const Spacer(),
              CustomButton(
                text: "Simpan",
                onPressed: () {
                  setState(() {
                    selectedDateRange = "12 Aug - 17 Aug"; // Dummy Update
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(widget.vehicle.imageAsset),
                        fit: BoxFit.cover,
                      ),
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
                          widget.vehicle.price,
                          style: const TextStyle(fontSize: 12, color: AppPallete.greyText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 2. DURASI SEWA
            const Text("Durasi Sewa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showCalendarModal, // Buka Modal Kalender
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
                        const Text("Date", style: TextStyle(fontSize: 10, color: AppPallete.greyText)),
                        Text(
                          selectedDateRange,
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
            _buildPriceRow("Periode Waktu", "5 Hari"),
            const SizedBox(height: 8),
            _buildPriceRow("Pembayaran", "Rp 2.500.000"),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Rp. 2.500.000", style: TextStyle(fontWeight: FontWeight.bold, color: AppPallete.primary, fontSize: 16)),
              ],
            ),

            const Spacer(),

            // 5. TOMBOL KONFIRMASI
            CustomButton(
              text: "Konfirmasi & Bayar",
              onPressed: () {
                // Navigasi ke Halaman Sukses
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SuccessScreen()),
                );
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

  // Widget Dummy Kalender Sederhana (Visual Saja)
  Widget _buildDummyCalendar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Agustus 2025", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.chevron_right),
          ],
        ),
        const SizedBox(height: 16),
        // Grid Tanggal Statis
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: 31,
          itemBuilder: (context, index) {
            final day = index + 1;
            // Highlight tanggal 12
            final isSelected = day == 12; 
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppPallete.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$day",
                style: TextStyle(
                  color: isSelected ? Colors.white : AppPallete.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}