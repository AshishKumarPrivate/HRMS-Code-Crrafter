import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title, time, subtitle, points;
  final IconData icon;
  final Color color;

  const InfoCard({super.key, required this.title, required this.time, required this.subtitle, required this.points, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, blurRadius: 2, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle()),
            if (points.isNotEmpty) Text(points, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}