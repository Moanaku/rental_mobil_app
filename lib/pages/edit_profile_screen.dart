import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers tanpa initial value (akan diisi dari API)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Loading & User ID
  bool _isLoading = true;
  bool _isSaving = false;
  int? _userId;
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Load User Data dari AuthService
  Future<void> _loadUserData() async {
    try {
      final userData = await AuthService.getUserData();
      if (mounted && userData != null) {
        setState(() {
          _userId = userData['id'];
          _userName = userData['name'] ?? '';
          
          // Set text controllers dengan data user
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          
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

  // Save Updated Profile
  Future<void> _saveProfile() async {
    // Validasi input
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final apiService = ApiService();
      
      // Call API update profile
      final result = await apiService.updateProfile(
        userId: _userId!,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        // Update local storage dengan data baru
        await AuthService.saveUserData({
          'id': _userId,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        });

        // Navigate back dengan success message
        Navigator.pop(context, true); // Return true untuk refresh parent
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal memperbarui profil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppPallete.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppPallete.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // 1. Avatar Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png"
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // dynamic User Name
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.black,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 2. Form Fields 
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Nama Lengkap",
                      prefixIcon: const Icon(Icons.person_outline, color: AppPallete.greyText),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppPallete.greyText),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Nomor HP",
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppPallete.greyText),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 3. Button Simpan 
                    _isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: "Simpan",
                            onPressed: _saveProfile,
                          ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}