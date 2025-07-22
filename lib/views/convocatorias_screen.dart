import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/servicios_card.dart'; // Reutilizamos el mismo widget

class ConvocatoriasScreen extends StatelessWidget {
  const ConvocatoriasScreen({super.key});

  final List<Map<String, dynamic>> carreras = const [
    {
      'title': 'PEDAGOGÍA EN INGLÉS',
      'url': 'https://fahu.usach.cl/ingles',
      'color': Colors.blue
    },
    {
      'title': 'PEDAGOGÍA EN CASTELLANO',
      'url': 'https://fahu.usach.cl/castellano',
      'color': Colors.green
    },
    {
      'title': 'LINGÜÍSTICA APLICADA A LA TRADUCCIÓN',
      'url': 'https://fahu.usach.cl/linguistica',
      'color': Colors.orange
    },
    {
      'title': 'PERIODISMO',
      'url': 'https://fahu.usach.cl/periodismo',
      'color': Colors.purple
    },
    {
      'title': 'LICENCIATURA EN ESTUDIOS INTERNACIONALES',
      'url': 'https://fahu.usach.cl/estudios-internacionales',
      'color': Colors.red
    },
    {
      'title': 'PSICOLOGÍA',
      'url': 'https://fahu.usach.cl/psicologia',
      'color': Colors.teal
    },
    {
      'title': 'PEDAGOGÍA EN FILOSOFÍA',
      'url': 'https://fahu.usach.cl/filosofia',
      'color': Colors.indigo
    },
    {
      'title': 'LICENCIATURA EN HISTORIA',
      'url': 'https://fahu.usach.cl/historia',
      'color': Colors.cyan
    },
    {
      'title': 'PEDAGOGÍA EN HISTORIA',
      'url': 'https://fahu.usach.cl/pedagogia-historia',
      'color': Colors.deepOrange
    },
    {
      'title': 'PEDAGOGÍA EN EDUCACIÓN GENERAL BÁSICA',
      'url': 'https://fahu.usach.cl/educacion-basica',
      'color': Colors.brown
    },
  ];

  void _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convocatorias Ayudantías'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: carreras.map((carrera) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ServiceCard(
                icon: Icons.school,
                title: carrera['title'],
                description: 'Ir al sitio web oficial',
                color: carrera['color'].shade700,
                onTap: () => _abrirUrl(carrera['url']),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
