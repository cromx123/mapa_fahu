// views/servicios_screen.dart
import 'package:flutter/material.dart';

class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
        ),
      ),
    );
  }
}
