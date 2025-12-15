import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';

class BrandLargeCard extends StatelessWidget {
  final String brandName;
  final IconData icon; // Nanti diganti Image Asset/Network
  final String totalUnits;
  final String startPrice;
  final VoidCallback onTap;

  const BrandLargeCard({
    super.key,
    required this.brandName,
    required this.icon,
    required this.totalUnits,
    required this.startPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.border.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Logo Brand (Kotak Kiri)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: AppPallete.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 40, color: AppPallete.black),
          ),
          
          const SizedBox(width: 16),
          
          // 2. Info & Tombol (Kanan)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tersedia $totalUnits unit",
                  style: const TextStyle(fontSize: 12, color: AppPallete.greyText),
                ),
                Text(
                  "Mulai dari $startPrice/hari",
                  style: const TextStyle(fontSize: 12, color: AppPallete.greyText),
                ),
                const SizedBox(height: 12),
                
                // Tombol Lihat Detail
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Lihat Detail",
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.white, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}