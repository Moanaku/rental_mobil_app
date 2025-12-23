import 'package:flutter/foundation.dart';
import '../models/vehicle_model.dart';

class WishlistService extends ChangeNotifier {
  // Singleton Pattern (Agar data bisa diakses dari mana saja)
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  // List penyimpanan data
  final List<Vehicle> _wishlist = [];

  // Getter
  List<Vehicle> get wishlist => _wishlist;

  // Cek status
  bool isFavorite(int vehicleId) {
    return _wishlist.any((item) => item.id == vehicleId);
  }

  // Toggle (Tambah/Hapus)
  void toggleWishlist(Vehicle vehicle) {
    if (isFavorite(vehicle.id)) {
      _wishlist.removeWhere((item) => item.id == vehicle.id);
    } else {
      _wishlist.add(vehicle);
    }
    // Memberitahu listener (jika pakai Provider/ChangeNotifier nanti)
    notifyListeners();
  }
}