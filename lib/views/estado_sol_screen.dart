// views/estado_sol_screen.dart
import 'package:flutter/material.dart';

class EstadosSolicitudesScreen extends StatelessWidget {
  const EstadosSolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Estudiante'),
          ),
          ListTile(
            title: Text('Tipo de Solicitud'),
          ),
          ListTile(
            title: Text('Razones'),
          ),
          ListTile(
            title: Text('Documentos'),
          ),
          ListTile(
            title: Text('Estado de la solicitud'),
          ),
          ListTile(
            title: Text('Historial y firmas'),
          ),
            
        ],
      ),
    );
  }
}
