import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/supabase_client.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<bool> login(String email, String password) async {
    final response =
        await _client
            .from('Users')
            .select('email, password, role')
            .eq('email', email)
            .single();

    if (response == null) return false;

    if (response['password'] == password) {
      return true;
    }
    return false;
  }

  Future<String?> getUserRole(String email) async {
    try {
      final response =
          await _client
              .from('Users')
              .select('role')
              .eq('email', email)
              .single();
      return response?['role'];
    } catch (e) {
      print('Get Role error: $e');
      return null;
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      final username = email.split('@')[0];

      await _client.from('Users').insert({
        'email': email,
        'password': password, // 🔔 Note: Password sebaiknya di-hash.
        'username': username,
        'role': 'User',
      });
      return null; // sukses
    } catch (e) {
      print('Register error: $e');
      return e.toString(); // kirim error ke UI
    }
  }

  Future<bool> checkUserEmail(String email) async {
    try {
      final response =
          await _client
              .from('Users')
              .select('email')
              .eq('email', email)
              .maybeSingle();

      return response != null;
    } catch (e) {
      print('Check email error: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final data =
          await _client
              .from('Users')
              .update({'password': newPassword})
              .eq('email', email)
              .select();

      if (data != null && data.isNotEmpty) {
        print("Password berhasil diubah untuk: $email");
        return true;
      }

      print("Tidak ada data yang diubah.");
      return false;
    } catch (e) {
      print("Reset password error: $e");
      return false;
    }
  }
}
