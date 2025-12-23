import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../models/vehicle_model.dart'; 
import '../services/wishlist_service.dart';

class VehicleCard extends StatefulWidget {
  final Vehicle vehicle; 
  final VoidCallback? onTap;
  
  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
  });

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  // Ambil instance service wishlist
  final WishlistService _wishlistService = WishlistService();

  // Fungsi helper untuk format Rupiah
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

  // Helper widget agar kode lebih bersih
  Widget _buildSpecText(String text) {
    String displayText = (text.isEmpty || text == 'null' || text.toLowerCase() == 'null') ? '-' : text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppPallete.greyText.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          color: AppPallete.greyText,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek status favorite dari service saat build
    // Ini memastikan status icon selalu sinkron dengan data di service
    bool isLiked = _wishlistService.isFavorite(widget.vehicle.id);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppPallete.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppPallete.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Section (ANTI CRASH)
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.vehicle.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, color: Colors.grey, size: 40),
                              SizedBox(height: 4),
                              Text("Gagal Muat", style: TextStyle(color: Colors.grey, fontSize: 10)),
                            ],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 24, 
                            height: 24, 
                            child: CircularProgressIndicator(strokeWidth: 2)
                          )
                        );
                      },
                    ),
                  ),
                ),
                
                // [FITUR BARU] Icon Love yang Berfungsi
                Positioned(
                  top: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // 1. Panggil service untuk toggle (tambah/hapus)
                        _wishlistService.toggleWishlist(widget.vehicle);
                      });
                      
                      // 2. Tampilkan Feedback SnackBar
                      ScaffoldMessenger.of(context).clearSnackBars(); // Hapus snackbar lama biar ga numpuk
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isLiked 
                            ? "Dihapus dari Favorite" 
                            : "Ditambahkan ke Favorite"),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating, // Tampil melayang
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(10),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPallete.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      ),
                      child: Icon(
                        // Jika isLiked true, tampilkan hati penuh (favorite)
                        // Jika false, tampilkan hati kosong (favorite_border)
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 22,
                        // Jika isLiked true, warnanya Merah
                        // Jika false, warnanya Abu-abu
                        color: isLiked ? AppPallete.redError : AppPallete.greyText,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vehicle.name.isNotEmpty ? widget.vehicle.name : "Tanpa Nama",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Divider(color: AppPallete.border.withOpacity(0.6)),
                  const SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kiri: Spesifikasi (Scrollable)
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildSpecText(widget.vehicle.engineCapacity),
                              const SizedBox(width: 8),

                              _buildSpecText(widget.vehicle.transmission),
                              const SizedBox(width: 8),

                              _buildSpecText(widget.vehicle.fuel),
                              const SizedBox(width: 8),
                              
                              if (widget.vehicle.seats > 0)
                                _buildSpecText("${widget.vehicle.seats} Kursi"),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),

                      // Kanan: Harga
                      Text(
                        _formatCurrency(widget.vehicle.pricePerDay),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}