import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String title, date, time, status, points;
  final Color color;

  const ActivityTile({super.key, required this.title, required this.date, required this.time, required this.status, required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withAlpha(50), child: Icon(Icons.circle, color: color)),
        title: Text(title),
        subtitle: Text('$date • $status'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(points, style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}