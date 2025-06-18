// main.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const CampusMapApp());

class CampusMapApp extends StatelessWidget {
  const CampusMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa del Campus',
      home: const CampusMapScreen(),
    );
  }
}

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del Campus'),
        backgroundColor: Colors.redAccent,
        actions: [
          const Icon(Icons.search),
          const SizedBox(width: 10),
          const Icon(Icons.mic),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Busca aquí',
                prefixIcon: const Icon(Icons.location_pin),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    child: Image.asset('assets/images/mapa_screen.png'), // Usa tu imagen aquí
                  ),
                ),
                const Positioned(
                  left: 130,
                  top: 200,
                  child: Column(
                    children: [
                      Icon(Icons.location_pin, color: Colors.red, size: 30),
                      Text('Facultad de Humanidades'),
                    ],
                  ),
                ),
                const Positioned(
                  left: 20,
                  bottom: 0,
                  right: 20,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Información de la búsqueda', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text('Nombre:'),
                          Text('Piso:'),
                          Text('Sala:'),
                          Text('Sector:'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true, // evita scroll interno
                      physics: const NeverScrollableScrollPhysics(), // evita conflictos de scroll
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: const [
                        MenuItem(icon: Icons.school, label: 'Portal Usach', url: 'https://www.usach.cl/'),
                        MenuItem(icon: Icons.person, label: 'Portal\naAlumnos', url: 'https://registro.usach.cl/index.php'),
                        MenuItem(icon: Icons.visibility, label: 'Servicios\nEn línea', url: 'https://www.serviciosweb.usach.cl/login'),
                        MenuItem(icon: Icons.menu_book, label: 'Biblioteca', url: 'https://biblioteca.usach.cl/'),
                        MenuItem(icon: Icons.headset_mic, label: 'Usach\nAtiende'),
                        MenuItem(icon: Icons.notifications, label: 'Notificaciones'),
                        MenuItem(icon: Icons.settings, label: 'Configuración'),
                        MenuItem(icon: Icons.help_outline, label: 'Ayuda'),
                        MenuItem(icon: Icons.info, label: 'Información'),
                        MenuItem(icon: Icons.logout, label: 'Cerrar sesión'),
                        MenuItem(), MenuItem(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '© 2025 Cromx && Gabo && Fahu\nversión 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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