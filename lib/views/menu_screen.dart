// views/menu_screen.dart
import 'package:flutter/material.dart';
import '../widgets/menu_item.dart';

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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: const [
                        MenuItem(icon: Icons.school, label: 'Portal Usach', url: 'https://www.usach.cl/'),
                        MenuItem(icon: Icons.person, label: 'Portal\nAlumnos', url: 'https://registro.usach.cl/index.php'),
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
