import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle_model.dart';
import '../models/brand_model.dart';
import '../models/transaction_model.dart';
import 'auth_service.dart'; 

class ApiService {
  static const String baseUrl = 'http://192.168.1.18:8000/api';

  Future<List<T>> _fetchList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final List<dynamic> data = jsonData['data'];
          return data.map((json) => fromJson(json)).toList();
        } else {
          throw Exception(
            'API Error: ${jsonData['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetching $endpoint: $e');
      rethrow;
    }
  }

  // ========== AUTHENTICATION ==========

  // Register Function
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
    String address,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          // 'address': address, // Uncomment jika Laravel butuh address
        }),
      );

      print("📤 Register Status: ${response.statusCode}");
      print("📥 Register Body: ${response.body}");

      final data = json.decode(response.body);

      // Cek status code 201 (Created) untuk registrasi berhasil
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi Berhasil',
          'data': data,
        };
      } 
      // Status 200 kadang dipakai Laravel untuk register berhasil
      else if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi Berhasil',
          'data': data,
        };
      }
      // Registrasi Gagal
      else {
        String errorMessage = data['message'] ?? 'Registrasi Gagal';

        return {
          'success': false,
          'message': errorMessage,
          'errors': data['errors'], // Kirim errors untuk parsing di UI
        };
      }
    } catch (e) {
      print("Error Register: $e");
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // Login Function with Sanctum Token
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print("📤 Login Status: ${response.statusCode}");
      print("📥 Login Body: ${response.body}");

      final data = json.decode(response.body);

      // Login Berhasil
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'message': data['message'] ?? 'Login Berhasil',
          'data': data['data'], // User data
          'token': data['access_token'], // Ambil access_token dari Laravel
        };
      } 
      // Login Gagal
      else {
        return {
          'success': false,
          'message': data['message'] ?? 'Email atau password salah',
        };
      }
    } catch (e) {
      print("Error Login: $e");
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }

  // Logout Function
  Future<bool> logout() async {
    try {
      final token = await AuthService.getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await AuthService.logout(); // Clear local data
        return true;
      }
      return false;
    } catch (e) {
      print("Error Logout: $e");
      return false;
    }
  }

  // ========== VEHICLES ==========

  Future<List<Vehicle>> getVehicles() async {
    return _fetchList('/vehicles', (json) => Vehicle.fromJson(json));
  }

  Future<Vehicle?> getVehicleById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return Vehicle.fromJson(jsonData['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error in getVehicleById: $e');
      return null;
    }
  }

  // ========== BRANDS ==========

  Future<List<Brand>> getBrands() async {
    return _fetchList('/brands', (json) => Brand.fromJson(json));
  }

  // ========== TRANSACTIONS ==========

  Future<bool> createTransaction({
    required int vehicleId,
    required String startDate,
    required String endDate,
    required double totalPrice,
    required int userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'vehicle_id': vehicleId,
          'user_id': userId,
          'start_date': startDate,
          'end_date': endDate,
          'total_price': totalPrice,
          'status': 'pending',
          'payment_method': 'cash',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Transaction Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error createTransaction: $e');
      return false;
    }
  }

  // ========== RIWAYAT TRANSAKSI ==========
  
  // Ambil riwayat transaksi berdasarkan User ID
  Future<List<TransactionModel>> getHistory(int userId) async {
    try {
      // Panggil endpoint /transactions?user_id=...
      final url = Uri.parse('$baseUrl/transactions?user_id=$userId');
      // Debug print untuk memastikan URL 
      print("Fetching History URL: $url");

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print("History Response Code: ${response.statusCode}");
      // print("History Body: ${response.body}"); // Uncomment jika ingin lihat data mentah

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == 'success') {
          final List<dynamic> data = jsonData['data'] ?? []; // Handle null data
          
          return data.map((json) => TransactionModel.fromJson(json)).toList();
        } else {
          print("API Error Message: ${jsonData['message']}");
        }
      } else {
        print("Failed to load history. Status Code: ${response.statusCode}");
      }
      
      // Jika kosong atau gagal, kembalikan list kosong
      return [];
    } catch (e) {
      print('Error getHistory: $e');
      return [];
    }
  }

  // ========== USER PROFILE ==========

  Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final token = await AuthService.getToken();
      
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      print("📤 Update Profile Status: ${response.statusCode}");
      print("📥 Update Profile Body: ${response.body}");

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'message': data['message'] ?? 'Profile berhasil diperbarui',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memperbarui profile',
        };
      }
    } catch (e) {
      print("Error Update Profile: $e");
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi',
      };
    }
  }
}