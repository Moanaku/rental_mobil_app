import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller diisi data dummy agar terlihat seperti "Edit"
  final TextEditingController _nameController = TextEditingController(text: "Zulhida Zacky");
  final TextEditingController _emailController = TextEditingController(text: "11222@gmail.com");
  final TextEditingController _phoneController = TextEditingController(text: "08112412345");

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
      body: SafeArea(
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
                    // Placeholder avatar 3D
                    image: NetworkImage("https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png"),
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
              
              const SizedBox(height: 40),
              
              // 2. Form Fields
              CustomTextField(controller: _nameController, hintText: "Nama Lengkap"),
              const SizedBox(height: 16),
              CustomTextField(controller: _emailController, hintText: "Email"),
              const SizedBox(height: 16),
              CustomTextField(controller: _phoneController, hintText: "Nomor HP"),
              
              const SizedBox(height: 40),
              
              // 3. Button Simpan
              CustomButton(
                text: "Simpan",
                onPressed: () {
                  // Simulasi simpan & kembali
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profil berhasil diperbarui!")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}