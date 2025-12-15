import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';

class BrandItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;

  const BrandItem({
    super.key,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppPallete.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppPallete.primary : AppPallete.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), // FIX: Pakai withValues
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Icon(icon, size: 32, color: AppPallete.black),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppPallete.black,
          ),
        ),
      ],
    );
  }
}