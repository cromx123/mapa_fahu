// views/menu_screen.dart
import 'package:flutter/material.dart';
import '../widgets/menu_item.dart';
import 'package:humanidades360/l10n/app_localizations.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent, // fondo transparente
      body: Row(
        children: [
          // Parte que ocupa 1/5, al tocarla se cierra
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black.withOpacity(0.3), // semi-transparente
              ),
            ),
          ),
          // Menú que ocupa 4/5
          Container(
            width: screenWidth * 0.8,
            color: theme.scaffoldBackgroundColor, // adapta color de fondo según tema
              child: Column(
                children: [
                  // Encabezado con curva y título
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.primaryColor, // azul usach
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        localizations.ms_menuTitle,
                        style: TextStyle(
                          fontSize: 28,
                          color: const Color(0xFFE77500), // naranjo usach
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SafeArea(
                      child: Column(
                        children:[
                          ListTile(
                            leading: Icon(Icons.login, color: theme.iconTheme.color),
                            title: Text(
                              localizations.ms_login,
                              style: theme.textTheme.bodyMedium,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/solicitudes_screen');
                            },
                          ),
                          const Divider(),
                          // Lista de opciones
                          Expanded(
                            child: ListView(
                              children: [
                                MenuItem(icon: Icons.school, label: localizations.ms_portalUsach, url: 'https://www.usach.cl/'),
                                MenuItem(icon: Icons.laptop, label: localizations.ms_portalFahu, url: 'https://fahu.usach.cl/'),
                                MenuItem(icon: Icons.person, label: localizations.ms_portalAlumnos, url: 'https://registro.usach.cl/index.php'),
                                MenuItem(
                                  icon: Icons.laptop,
                                  label: localizations.ms_onlineServices,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/servicios_screen');
                                  },
                                ),
                                MenuItem(icon: Icons.menu_book, label: localizations.ms_onlineLibrary, url: 'https://biblioteca.usach.cl/'),
                                MenuItem(
                                  icon: Icons.settings,
                                  label: localizations.ms_settings,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/config_screen');
                                  },
                                ),
                                const MenuItem(icon: Icons.info, label: 'Ayuda e información'),
                              ],
                            ),
                          ),
                          // Pie de página
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Solutions maps & Fahu\n1.0.3',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ),
                        ]
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
