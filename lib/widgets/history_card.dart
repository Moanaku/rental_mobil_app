import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../models/transaction_model.dart'; 

class HistoryCard extends StatelessWidget {
  final TransactionModel transaction; 

  const HistoryCard({
    super.key,
    required this.transaction,
  });

  // Helper Warna Status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'active': // Sedang Disewa
      case 'on rent':
        return const Color(0xFF76FF03); 
      case 'completed':
        return const Color(0xFF00C853); 
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper Teks Status
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return 'Menunggu Bayar';
      case 'active': return 'Sedang Disewa';
      case 'completed': return 'Selesai';
      case 'cancelled': return 'Dibatalkan';
      default: return status;
    }
  }

  // Helper Format Rupiah
  String _formatCurrency(double price) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Gambar Mobil
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              transaction.vehicleImage, // Dari API
              width: 80,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80, 
                  height: 60, 
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Info Transaksi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.vehicleName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(transaction.totalPrice),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppPallete.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // Tanggal Sewa
                Text(
                  "${transaction.startDate} - ${transaction.endDate}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _getStatusColor(transaction.status)),
            ),
            child: Text(
              _getStatusText(transaction.status),
              style: TextStyle(
                color: _getStatusColor(transaction.status),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}