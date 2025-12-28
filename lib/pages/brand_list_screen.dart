import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/brand_large_card.dart'; 
import 'brand_detail_screen.dart';
import '../services/api_service.dart';
import '../models/brand_model.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  final ApiService _apiService = ApiService();
  
  // Data dari API
  List<Brand> _brands = [];
  bool _isLoading = true;

  // Filter Statis (UI Only, karena API brand biasanya tidak punya kategori)
  int _selectedIndex = 0;
  final List<String> _filters = ["Semua Kendaraan", "Mobil", "Motor"];

  @override
  void initState() {
    super.initState();
    _fetchBrands();
  }

  // Mengambil data Brand dari API
  Future<void> _fetchBrands() async {
    try {
      final brands = await _apiService.getBrands();
      if (mounted) {
        setState(() {
          _brands = brands;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint("Error fetching brands: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat brand: $e')),
        );
      }
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

            // 2. LIST DATA (Dari API)
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : _brands.isEmpty
                  ? const Center(child: Text("Belum ada brand tersedia"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _brands.length,
                      itemBuilder: (context, index) {
                        final brand = _brands[index];
                        return BrandLargeCard(
                          brandName: brand.name,
                          imageUrl: brand.logoUrl, 
                          
                          totalUnits: "Cek Unit", 
                          startPrice: "Lihat Detail", 
                          
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrandDetailScreen(
                                  // Kirim ID jika BrandDetailScreen butuh ID untuk fetch by brand_id
                                  // atau kirim nama jika fetch by name
                                  brandName: brand.name, 
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