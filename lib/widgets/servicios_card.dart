import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? route;
  final Color? color;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.route,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Added missing closing parenthesis here
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? (route != null ? () => Navigator.pushNamed(context, route!) : null),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icono con fondo circular
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: effectiveColor),
              ),
              
              const SizedBox(width: 16),
              
              // Contenido de texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Flecha de navegación (si tiene ruta o acción)
              if (route != null || onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}