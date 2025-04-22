// lib/models/dashboard_data.dart

class DashboardData {
  final int totalTransaksi;
  final double totalPendapatan;
  final double totalPengeluaran;

  DashboardData({required this.totalTransaksi, required this.totalPendapatan, required this.totalPengeluaran});

  // Fungsi untuk parse data dari JSON (misalnya dari API)
  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalTransaksi: json['total_transaksi'],
      totalPendapatan: json['total_pendapatan'],
      totalPengeluaran: json['total_pengeluaran'],
    );
  }
}
