import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/supabase_client.dart';

class StatsAdminScreen extends StatefulWidget {
  const StatsAdminScreen({super.key});

  @override
  State<StatsAdminScreen> createState() => _StatsAdminScreenState();
}

class _StatsAdminScreenState extends State<StatsAdminScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _monthlyStats = [];

  @override
  void initState() {
    super.initState();
    fetchMonthlyStats();
  }

  Future<void> fetchMonthlyStats() async {
    setState(() => _isLoading = true);
    try {
      final supabase = SupabaseConfig.client;
      final response = await supabase
          .from('Reservasi')
          .select('tanggal_pesanan')
          .order('tanggal_pesanan', ascending: true);

      final Map<String, int> stats = {};
      for (final item in response) {
        final date = DateTime.parse(item['tanggal_pesanan']);
        final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";
        stats[key] = (stats[key] ?? 0) + 1;
      }

      _monthlyStats =
          stats.entries
              .map((e) => {'bulan': e.key, 'jumlah': e.value})
              .toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Gagal memuat data laporan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset(
                "assets/images/Logo_White.png",
                height: 30,
                width: 30,
              ),
            ),
            const Text(
              'Laporan Reservasi Bulanan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white), // back arrow putih
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _monthlyStats.isEmpty
              ? const Center(child: Text('Belum ada data reservasi.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _monthlyStats.length,
                itemBuilder: (context, index) {
                  final stat = _monthlyStats[index];
                  final bulan = _formatBulan(stat['bulan']);
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.bar_chart, color: Colors.green),
                      title: Text(bulan),
                      trailing: Text(
                        "${stat['jumlah']} reservasi",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  String _formatBulan(String ym) {
    final parts = ym.split('-');
    final bulan = int.parse(parts[1]);
    final tahun = parts[0];
    const namaBulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return "${namaBulan[bulan]} $tahun";
  }
}
