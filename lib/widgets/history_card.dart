// lib/widgets/history_card.dart
import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';

class HistoryCard extends StatelessWidget {
  final String name;
  final String imageAsset;
  final String price;
  final String status;
  final Color statusColor;

  const HistoryCard({
    super.key,
    required this.name,
    required this.imageAsset,
    required this.price,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Gunakan withOpacity atau withValues sesuai versi Flutter Anda
          color: AppPallete.border.withOpacity(0.5), 
        ),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Gambar Kecil di Kiri
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 2. Informasi di Kanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Text Lokasi (Placeholder sesuai desain)
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: AppPallete.greyText),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Jalan Poros Utama Kawasan...",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppPallete.greyText.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Baris Harga dan Status
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                        price,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppPallete.black,
                        ),
                     ),
                     // Badge Status
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                       decoration: BoxDecoration(
                         color: statusColor,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Text(
                         status,
                         style: const TextStyle(
                           fontSize: 10,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         ),
                       ),
                     )
                   ]
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}