// views/config_screen.dart
import 'package:flutter/material.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.language, color: Colors.black),
            title: Text('Idioma'),
          ),
          ListTile(
            leading: Icon(Icons.color_lens, color: Colors.black),
            title: Text('Tema'),
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.black),
            title: Text('Notificaciones'),
          ),
          ListTile(
            leading: Icon(Icons.save, color: Colors.black),
            title: Text('Trayectos Guardados'),
          ),
          ListTile(
            leading: Icon(Icons.drive_file_rename_outline_sharp, color: Colors.black),
            title: Text('Unidad de Medida'),
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.black),
            title: Text('Ayuda y Soporte'),
          ),
            
        ],
      ),
    );
  }
}
