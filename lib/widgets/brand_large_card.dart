import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';

class BrandLargeCard extends StatelessWidget {
  final String brandName;
  final String imageUrl; 
  final String totalUnits;
  final String startPrice;
  final VoidCallback onTap;

  const BrandLargeCard({
    super.key,
    required this.brandName,
    required this.imageUrl,
    required this.totalUnits,
    required this.startPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppPallete.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // LOGO BRAND (Network Image)
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // DETAIL TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppPallete.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalUnits,
                    style: const TextStyle(
                      color: AppPallete.greyText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // HARGA / ACTION
            Text(
              startPrice,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppPallete.primary,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppPallete.greyText),
          ],
        ),
      ),
    );
  }
}