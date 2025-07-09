// views/menu_screen.dart
import 'package:flutter/material.dart';
import '../widgets/menu_item.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent, // fondo transparente
      body: Row(
        children: [
          // Menú que ocupa 4/5
          Container(
            width: screenWidth * 0.8, // 4/5
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  // Encabezado con curva y título
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF009688),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Botón de iniciar sesión
                  ListTile(
                    leading: const Icon(Icons.login, color: Colors.grey),
                    title: const Text(
                      'Iniciar sesión',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(),
                  // Lista de opciones
                  Expanded(
                    child: ListView(
                      children: [
                        const MenuItem(icon: Icons.school, label: 'Portal USACH', url: 'https://www.usach.cl/'),
                        const MenuItem(icon: Icons.person, label: 'Portal Alumnos', url: 'https://registro.usach.cl/index.php'),
                        const MenuItem(icon: Icons.visibility, label: 'Servicios en Línea', url: 'https://www.serviciosweb.usach.cl/login'),
                        const MenuItem(icon: Icons.menu_book, label: 'Biblioteca en Línea', url: 'https://biblioteca.usach.cl/'),
                        MenuItem(
                          icon: Icons.settings,
                          label: 'Configuración',
                          onTap: () {
                            Navigator.pushNamed(context, '/config_screen');
                          },
                        ),
                        const MenuItem(icon: Icons.info, label: 'Ayuda e información'),
                      ],
                    ),
                  ),
                  // Pie de página
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Solutions maps & Fahu\n1.0.1',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Parte que ocupa 1/5, al tocarla se cierra
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.3), // semi-transparente
              ),
            ),
          ),
        ],
      ),
    );
  }
}
