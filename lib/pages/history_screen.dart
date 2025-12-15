// lib/pages/history_screen.dart
import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/history_card.dart'; // Import widget baru

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. HEADER
              const Text(
                "Riwayat",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),

              const SizedBox(height: 24),

              // 2. SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CustomTextField(
                  controller: searchController,
                  hintText: "Cari Riwayat?",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppPallete.greyText,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. LIST RIWAYAT
              Expanded(
                child: ListView(
                  children: const [
                    // Item 1: Menunggu Bayar (Kuning/Orange)
                    HistoryCard(
                      name: "Cbr 250Rr",
                      imageAsset:
                          "https://statik.tempo.co/data/2022/09/19/id_1142512/1142512_720.jpg",
                      price: "Rp.50.000",
                      status: "Menunggu Bayar",
                      statusColor: Colors.orange,
                    ),

                    // Item 2: Sedang Disewa (Hijau Muda)
                    HistoryCard(
                      name: "Pajero Dakar 4x4",
                      imageAsset:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/2019_Mitsubishi_Pajero_Sport_2.4_Dakar_Ultimate_4x2_KR1W_%2820240519%29.jpg/1200px-2019_Mitsubishi_Pajero_Sport_2.4_Dakar_Ultimate_4x2_KR1W_%2820240519%29.jpg",
                      price: "Rp.500.000",
                      status: "Sedang Disewa",
                      statusColor: Color(0xFF76FF03), // Hijau terang
                    ),

                    // Item 3: Selesai (Hijau Normal)
                    HistoryCard(
                      name: "Honda Brio",
                      imageAsset:
                          "https://img.cintamobil.com/2021/01/12/20210112104046-6084.png",
                      price: "Rp.100.000",
                      status: "Selesai",
                      statusColor: Color(0xFF00C853), // Hijau standar
                    ),

                    SizedBox(
                      height: 80,
                    ), // Jarak bawah agar tidak tertutup navbar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
