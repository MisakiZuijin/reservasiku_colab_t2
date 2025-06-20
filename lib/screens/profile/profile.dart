import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/nav_controller.dart';
import '../../services/auth_service.dart';
import '../../utils/app_route.dart';
import '../../utils/supabase_client.dart';
import '../../widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String? _username;
  String? _avatarUrl;
  String? _email;
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final data = await _authService.getProfile();
      final user = SupabaseConfig.client.auth.currentUser;

      setState(() {
        _username = data?['username'];
        _avatarUrl = data?['image'];
        _email = user?.email;
        _usernameController.text = _username ?? '';
      });
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isLoading = true);

    try {
      final fileName =
          '${SupabaseConfig.client.auth.currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      String imageUrl;

      if (kIsWeb) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        imageUrl = await _authService.uploadImage(
          bucket: 'avatars',
          fileName: fileName,
          bytes: bytes,
        );
      } else {
        final file = File(pickedFile.path);
        imageUrl = await _authService.uploadImage(
          bucket: 'avatars',
          fileName: fileName,
          file: file,
        );
      }

      await _authService.updateProfile(
        username: _usernameController.text.trim(),
        avatarUrl: imageUrl,
      );
      await _loadProfile();
      Get.snackbar('Berhasil', 'Foto profil berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal upload gambar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (_usernameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await _authService.updateProfile(
        username: _usernameController.text.trim(),
      );
      await _loadProfile();
      Get.snackbar('Sukses', 'Username berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui username: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    final navController = Get.find<NavController>();
    navController.handleLogout();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/Logo_White.png",
            height: 10,
            width: 10,
            fit: BoxFit.cover,
          ),
        ),
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
        elevation: 4,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                _avatarUrl != null
                                    ? NetworkImage(_avatarUrl!)
                                    : null,
                            child:
                                _avatarUrl == null
                                    ? const Icon(Icons.person, size: 60)
                                    : null,
                          ),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, size: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(_email ?? '-', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _updateProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
