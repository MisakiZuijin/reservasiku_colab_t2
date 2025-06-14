import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://bgekjhxmuyhwjmpnausm.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJnZWtqaHhtdXlod2ptcG5hdXNtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk1NDI3MTIsImV4cCI6MjA2NTExODcxMn0.vOT7U4_A4s-YzUXazA0dZUPZUQ2oDBUt8P8bzvRKza4';

  static Future<void> init() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
