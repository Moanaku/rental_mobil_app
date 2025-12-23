import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../models/vehicle_model.dart';
import '../widgets/custom_button.dart';
import 'payment_screen.dart';
import '../services/wishlist_service.dart'; 

class DetailVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;

  const DetailVehicleScreen({super.key, required this.vehicle});

  @override
  State<DetailVehicleScreen> createState() => _DetailVehicleScreenState();
}

class _DetailVehicleScreenState extends State<DetailVehicleScreen> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    // Cek status saat ini
    bool isLiked = _wishlistService.isFavorite(widget.vehicle.id);

    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Positioned(
            top: 0, left: 0, right: 0, height: 350,
            child: Container(
              color: Colors.grey[200],
              child: Image.network(
                widget.vehicle.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]),
              ),
            ),
          ),

          // 2. HEADER BUTTONS
          Positioned(
            top: 50, left: 24, right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIcon(Icons.arrow_back_ios_new, onTap: () => Navigator.pop(context)),
                
                // TOMBOL FAVORITE INTERAKTIF
                _buildCircleIcon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? AppPallete.redError : AppPallete.black,
                  onTap: () {
                    setState(() {
                      _wishlistService.toggleWishlist(widget.vehicle);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isLiked 
                        ? "Dihapus dari Favorite" 
                        : "Ditambahkan ke Favorite"))
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. CONTENT
          Positioned.fill(
            top: 280,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.vehicle.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Spesifikasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSpecCard(Icons.settings, "Mesin", widget.vehicle.engineCapacity),
                        _buildSpecCard(Icons.settings_input_component, "Transmisi", widget.vehicle.transmission),
                        _buildSpecCard(Icons.local_gas_station, "Bahan Bakar", widget.vehicle.fuel),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    const Text("Deskripsi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      widget.vehicle.description,
                      style: const TextStyle(color: AppPallete.greyText, height: 1.5),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          // 4. BOTTOM BAR
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Harga", style: TextStyle(color: AppPallete.greyText, fontSize: 12)),
                      Text(
                        "Rp ${widget.vehicle.pricePerDay.toStringAsFixed(0)}/Hari",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppPallete.primary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: CustomButton(
                      text: "Sewa Sekarang",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(vehicle: widget.vehicle)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, {required VoidCallback onTap, Color color = AppPallete.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF007CC7), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}