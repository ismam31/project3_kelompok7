import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color color;
  final double? delay;
  final Widget? child; // Untuk grafik

  const DashboardCard({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    required this.color,
    this.delay = 0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color)
                .animate()
                .fadeIn(delay: (100 * delay!).ms) // Animasi fade-in
                .slideY(begin: 0.5, duration: 300.ms),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12))
                .animate()
                .fadeIn(delay: (150 * delay!).ms),
            const SizedBox(height: 8),
            child ?? 
              Text(value!, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              )).animate().fadeIn(delay: (200 * delay!).ms),
          ],
        ),
      ),
    ).animate().scale(delay: (50 * delay!).ms); // Efek scale saat muncul
  }
}

// Widget Grafik Mini (Contoh untuk "Trend Penjualan")
class MiniLineChart extends StatelessWidget {
  final List<double> data;
  
  const MiniLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: data.length - 1,
          minY: 0,
          maxY: data.reduce((a, b) => a > b ? a : b) + 10,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}