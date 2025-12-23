import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/profile_menu_button.dart'; 
import '../services/auth_service.dart';
import '../services/api_service.dart'; 
import 'edit_profile_screen.dart'; 
import 'login_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User data variables
  String _userName = 'Loading...';
  String _userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load User Data dari AuthService
  Future<void> _loadUserData() async {
    try {
      final userData = await AuthService.getUserData();
      if (mounted && userData != null) {
        setState(() {
          _userName = userData['name'] ?? 'User';
          _userEmail = userData['email'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Logout Function dengan API
  Future<void> _performLogout() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Call logout API
      final apiService = ApiService();
      await apiService.logout();

      // Navigate to login screen
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout gagal, silakan coba lagi'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppPallete.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Ilustrasi
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://ouch-cdn2.icons8.com/rN5wPZ-sF1nI2R0P_lE_C1rFwzFkFqA6k5F6k7F8k9.png",
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: const Icon(
                    Icons.exit_to_app_rounded,
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Apakah Kamu yakin mau keluar?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.black,
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Tombol Aksi
                Row(
                  children: [
                    // Tombol Batal
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0E0E0),
                          foregroundColor: AppPallete.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Batal"),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Tombol Keluar - panggil _performLogout
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          _performLogout(); // Logout dengan API
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Keluar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // 1. Header & Avatar
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),
              const SizedBox(height: 32),

              // Avatar
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Dynamic User Name dengan Loading State
              _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 150,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.black,
                      ),
                    ),

              // Optional: Tampilkan email juga
              if (!_isLoading && _userEmail.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppPallete.greyText,
                  ),
                ),
              ],

              const SizedBox(height: 50),

              // 2. Menu Buttons
              ProfileMenuButton(
                text: "Edit Profile",
                icon: Icons.edit_outlined,
                onTap: () async {
                  // Navigate dan tunggu result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                  
                  // Jika berhasil update, reload data
                  if (result == true) {
                    _loadUserData();
                  }
                },
              ),

              ProfileMenuButton(
                text: "Keluar",
                icon: Icons.logout_rounded,
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}