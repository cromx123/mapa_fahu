// widgets/menu_item.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuItem extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final String? url;

  const MenuItem({super.key, this.icon, this.label, this.url});

  void _launchURL(BuildContext context) async {
    if (url == null) return;

    final uri = Uri.parse(url!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: icon != null && label != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30, color: Colors.black),
                  const SizedBox(height: 8),
                  Text(
                    label!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
