// ==============================================================================
// Yoga24X AI Engineering OS — Wellness Charts & Analytics Screen
// Custom Painted Graphs for Stress vs Energy, Practice Breakdown & Vitals
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timeline_provider.dart';

class WellnessChartsScreen extends ConsumerWidget {
  const WellnessChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timelineNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Analytics & Trends', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCardsRow(theme),
            const SizedBox(height: 24),
            const Text('7-Day Stress vs. Energy Curve', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildCustomBezierGraph(theme),
            const SizedBox(height: 24),
            const Text('Practice Minutes Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildBarChartCard(theme),
            const SizedBox(height: 24),
            _buildHydrationConsistencyCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardsRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard('Avg Sleep', '7.4 hrs', Icons.bedtime, Colors.indigo),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard('Avg Stress', '3.8 / 10', Icons.spa, Colors.teal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard('Hydration', '92%', Icons.water_drop, Colors.blue),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String val, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBezierGraph(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildLegendItem('Energy Level', Colors.amber.shade800),
                const SizedBox(width: 16),
                _buildLegendItem('Stress Level', Colors.red.shade400),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter: _BezierCurvePainter(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => Text(day, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBarChartCard(ThemeData theme) {
    final days = [
      {'day': 'Mon', 'yoga': 45, 'medit': 20},
      {'day': 'Tue', 'yoga': 60, 'medit': 15},
      {'day': 'Wed', 'yoga': 30, 'medit': 30},
      {'day': 'Thu', 'yoga': 45, 'medit': 20},
      {'day': 'Fri', 'yoga': 75, 'medit': 25},
      {'day': 'Sat', 'yoga': 90, 'medit': 45},
      {'day': 'Sun', 'yoga': 60, 'medit': 30},
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildLegendItem('Yoga (min)', theme.colorScheme.primary),
                const SizedBox(width: 16),
                _buildLegendItem('Meditation (min)', Colors.teal),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((d) {
                final yH = (d['yoga'] as int) * 1.2;
                final mH = (d['medit'] as int) * 1.2;
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 10, height: yH, decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 4),
                        Container(width: 10, height: mH, decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(d['day'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHydrationConsistencyCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.water_drop, color: Colors.blue, size: 30),
        ),
        title: const Text('Hydration Consistency: 92%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: const Text('You have met your daily 3000ml water goal 13 out of the last 14 days. Excellent cellular hydration!'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}

class _BezierCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final energyPaint = Paint()
      ..color = Colors.amber.shade800
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final stressPaint = Paint()
      ..color = Colors.red.shade400
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Energy points (higher is better)
    final energyPoints = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.16, size.height * 0.4),
      Offset(size.width * 0.33, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.66, size.height * 0.2),
      Offset(size.width * 0.83, size.height * 0.35),
      Offset(size.width, size.height * 0.15),
    ];

    // Stress points (lower is better)
    final stressPoints = [
      Offset(0, size.height * 0.4),
      Offset(size.width * 0.16, size.height * 0.55),
      Offset(size.width * 0.33, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.66, size.height * 0.75),
      Offset(size.width * 0.83, size.height * 0.7),
      Offset(size.width, size.height * 0.85),
    ];

    _drawSmoothPath(canvas, energyPoints, energyPaint);
    _drawSmoothPath(canvas, stressPoints, stressPaint);
  }

  void _drawSmoothPath(Canvas canvas, List<Offset> points, Paint paint) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
