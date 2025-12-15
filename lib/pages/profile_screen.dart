import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/profile_menu_button.dart'; // Import widget yang baru dibuat
import 'edit_profile_screen.dart'; // Import halaman edit
import 'login_screen.dart'; // Import login untuk logout

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                // 1. Ilustrasi (Placeholder Icon karena tidak ada aset 3D)
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // Menggunakan gambar ilustrasi orang lari/keluar dari internet
                      image: NetworkImage(
                        "https://ouch-cdn2.icons8.com/rN5wPZ-sF1nI2R0P_lE_C1rFwzFkFqA6k5F6k7F8k9.png",
                      ),
                      // Atau gunakan icon jika internet lambat:
                      // icon: Icon(Icons.run_circle_outlined, size: 80, color: AppPallete.primary),
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Fallback jika gambar gagal load (opsional)
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

                // 2. Tombol Aksi (Row)
                Row(
                  children: [
                    // Tombol Batal (Abu-abu)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFE0E0E0,
                          ), // Abu-abu muda
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

                    // Tombol Keluar (Biru)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Tutup dialog
                          Navigator.pop(context);
                          // Kembali ke Login & Hapus semua history
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
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

              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: const DecorationImage(
                    // Avatar yang sama
                    image: NetworkImage(
                      "https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Zulhida Zacky",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.black,
                ),
              ),

              const SizedBox(height: 50),

              // 2. Menu Buttons
              ProfileMenuButton(
                text: "Edit Profile",
                icon: Icons.edit_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
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
