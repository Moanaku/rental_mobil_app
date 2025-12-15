import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/brand_large_card.dart';

// [BARU] Import halaman detail agar bisa dinavigasi
import 'brand_detail_screen.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  // 0: Semua, 1: Mobil, 2: Motor
  int _selectedIndex = 0;

  // Label Filter
  final List<String> _filters = ["Semua Kendaraan", "Mobil", "Motor"];

  // Data Dummy Brand (Simulasi Database)
  List<Map<String, dynamic>> get _currentData {
    final allBrands = [
      {
        "name": "Honda",
        "icon": Icons.commute,
        "unit": "5",
        "price": "Rp 100.000",
        "type": "Mobil",
      },
      {
        "name": "Mitsubishi",
        "icon": Icons.car_repair,
        "unit": "3",
        "price": "Rp 100.000",
        "type": "Mobil",
      },
      {
        "name": "Suzuki",
        "icon": Icons.electric_car,
        "unit": "4",
        "price": "Rp 100.000",
        "type": "Mobil",
      },
      {
        "name": "Toyota",
        "icon": Icons.directions_car,
        "unit": "6",
        "price": "Rp 100.000",
        "type": "Mobil",
      },
      {
        "name": "Yamaha",
        "icon": Icons.two_wheeler,
        "unit": "6",
        "price": "Rp 50.000",
        "type": "Motor",
      },
      {
        "name": "Kawasaki",
        "icon": Icons.two_wheeler,
        "unit": "2",
        "price": "Rp 150.000",
        "type": "Motor",
      },
    ];

    // Logika Filter
    if (_selectedIndex == 0) return allBrands; // Tampilkan Semua
    if (_selectedIndex == 1)
      return allBrands.where((e) => e['type'] == 'Mobil').toList();
    if (_selectedIndex == 2)
      return allBrands.where((e) => e['type'] == 'Motor').toList();
    return [];
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
          "Trending Brands",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppPallete.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppPallete.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. FILTER CHIPS (Scroll Samping)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isActive = _selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppPallete.primary
                              : AppPallete.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isActive
                                ? AppPallete.primary
                                : AppPallete.border,
                          ),
                        ),
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isActive ? Colors.white : AppPallete.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // 2. LIST DATA
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _currentData.length,
                itemBuilder: (context, index) {
                  final brand = _currentData[index];
                  return BrandLargeCard(
                    brandName: brand['name'],
                    icon: brand['icon'],
                    totalUnits: brand['unit'],
                    startPrice: brand['price'],
                    onTap: () {
                      // [UPDATE] Navigasi ke BrandDetailScreen saat diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrandDetailScreen(
                            brandName:
                                brand['name'], // Kirim nama brand (contoh: "Honda")
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
