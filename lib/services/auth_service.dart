import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:io' as io;
import '../utils/supabase_client.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<String?> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) return 'Registrasi gagal.';

      await _client.from('Users').insert({
        'id_user': user.id,
        'username': username,
        'role': 'User',
        'image': null,
      });

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> getUserRole() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final data =
          await _client
              .from('Users')
              .select('role')
              .eq('id_user', user.id)
              .single();

      return data['role'];
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<void> updateProfile({
    required String username,
    String? avatarUrl,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User tidak ditemukan.');

    await _client
        .from('Users')
        .update({
          'username': username,
          if (avatarUrl != null) 'image': avatarUrl,
        })
        .eq('id_user', user.id);
  }

  Future<String> uploadImage({
    required String bucket,
    required String fileName,
    io.File? file, // untuk mobile
    Uint8List? bytes, // untuk web
  }) async {
    final storage = _client.storage.from(bucket);

    if (kIsWeb) {
      if (bytes == null) throw Exception('Image bytes is required for Web.');
      await storage.uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );
    } else {
      if (file == null) throw Exception('File is required for Mobile.');
      await storage.upload(
        fileName,
        file,
        fileOptions: const FileOptions(upsert: true),
      );
    }

    final publicUrl = storage.getPublicUrl(fileName);
    return publicUrl;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data =
        await _client
            .from('Users')
            .select('username, image')
            .eq('id_user', user.id)
            .single();

    return data;
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo:
            'http://localhost:59566/reset-password', // <- PENTING sesuaikan dengan environment
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<void> resetPasswordWithCode(String code, String newPassword) async {
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.recovery,
        token: code,
      );

      if (response.session == null) {
        throw const AuthException('Code tidak valid atau sudah expired.');
      }

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
