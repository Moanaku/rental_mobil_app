import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/history_card.dart'; 
import '../models/transaction_model.dart'; 
import '../services/api_service.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  
  List<TransactionModel> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    try {
      // 1. Ambil User ID dari Penyimpanan Flutter (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      // Ambil 'user_id', jika belum ada (belum login) pakai default 1
      final int userId = prefs.getInt('user_id') ?? 1; 

      // 2. Panggil API dengan ID tersebut
      final data = await _apiService.getHistory(userId);
      
      if (mounted) {
        setState(() {
          _historyList = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint("Error fetching history: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. HEADER
              const Text(
                "Riwayat",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),

              const SizedBox(height: 24),

              // 2. SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CustomTextField(
                  controller: searchController,
                  hintText: "Cari Riwayat?",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppPallete.greyText,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. LIST RIWAYAT DARI API
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _historyList.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text("Belum ada riwayat sewa", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _historyList.length,
                        itemBuilder: (context, index) {
                          return HistoryCard(
                            transaction: _historyList[index],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}