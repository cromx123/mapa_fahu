// widgets/menu_item.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuItem extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final String? url;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    this.icon,
    this.label,
    this.url,
    this.onTap,
  });

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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap ?? () => _launchURL(context),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.iconTheme.color, // usa color del tema
        ),
        title: Text(
          label ?? '',
          style: theme.textTheme.bodyMedium, // usa estilo del tema
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.iconTheme.color?.withOpacity(0.6) ?? Colors.grey,
          size: 16,
        ),
      ),
    );
  }
}

