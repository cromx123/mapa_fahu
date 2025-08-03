import 'package:flutter/material.dart';
import '../widgets/servicios_card.dart';

class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ServiceCard(
              icon: Icons.work_outline,
              title: 'Convocatorias Ayudantías',
              description: 'Oportunidades para postular a ayudantías',
              route: '/convocatorias_screen',
              color: Colors.blue.shade700,
            ),
            
            ServiceCard(
              icon: Icons.school,
              title: 'Programas Académicos',
              description: 'Información sobre carreras y programas',
              color: Colors.green.shade700,
              onTap: () {
                // Acción personalizada si no es una ruta nombrada
                print('Programas Académicos seleccionado');
              },            
            ),
            
            ServiceCard(
              icon: Icons.event_available,
              title: 'Calendario Académico',
              description: 'Fechas importantes del año académico',
              color: Colors.orange.shade700,
              onTap: () {
                // Acción personalizada si no es una ruta nombrada
                print('Calendario seleccionado');
              },
            ),
            
            ServiceCard(
              icon: Icons.help_center,
              title: 'Asesorías Estudiantiles',
              description: 'Orientación y apoyo estudiantil',
              color: Colors.purple.shade700,
              onTap: () {
                // Acción personalizada si no es una ruta nombrada
                print('Asesorías seleccionadas');
              },
            ),
            ServiceCard(
              icon: Icons.contact_support,
              title: 'Eventos y Actividades',
              description: 'Listado de eventos y actividades del mes actual',
              color: Colors.red.shade700,
              onTap: () {
                // Acción personalizada si no es una ruta nombrada
                print('Eventos seleccionado');
              },
            ),
          ],
        ),
      ),
    );
  }
}