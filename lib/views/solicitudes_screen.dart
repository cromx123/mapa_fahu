// views/solicitudes_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'foto_screen.dart'; // agregar esta línea si no está
class SolicitudesView extends StatelessWidget {
  const SolicitudesView({super.key});

  final List<Map<String, dynamic>> solicitudes = const [
    {
      'tipo': 'Ampliación dfuera de plazo',
      'estado': 'Recepcionado',
      'fechaCreacion': '22/07/2025 12:24',
      'ultimaActualizacion': '22/07/2025 12:24',
      'documento': true,
    },
    {
      'tipo': 'Reincorporación por reprobación por segunda o más veces',
      'estado': 'Aceptada',
      'fechaCreacion': '10/07/2025 17:24',
      'ultimaActualizacion': '10/07/2025 17:24',
      'documento': true,
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16, // espacio horizontal entre los elementos
              runSpacing: 8, // espacio vertical entre las filas cuando saltan
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DropdownButton<String>(
                  value: 'Primer semestre del año 2025',
                  items: const [
                    DropdownMenuItem(
                      value: 'Primer semestre del año 2025',
                      child: Text('Primer semestre del año 2025'),
                    ),
                  ],
                  onChanged: null, // o tu lógica cuando la tengas
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Filtrar'),
                ),
               ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context,'/formulario_cae',
                   arguments: {
                   'logoHeader': FotoScreen.base64Logo,
                   'logoFooter': FotoScreen.base64Logo1,
                   },
                 );
               },
              child: const Text('Nueva solicitud'),
               ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: kIsWeb
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Tipo de solicitud')),
                          DataColumn(label: Text('Estado')),
                          DataColumn(label: Text('Fecha')),
                          DataColumn(label: Text('Documento')),
                          DataColumn(label: Text('Acciones')),
                        ],
                        rows: solicitudes.asMap().entries.map(
                          (entry) {
                            final solicitud = entry.value;
                            return DataRow(cells: [
                              DataCell(Text('${entry.key + 1}')),
                              DataCell(Text(solicitud['tipo'])),
                              DataCell(Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: solicitud['estado'] == 'Aceptada'
                                      ? Colors.green.shade100
                                      : Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  solicitud['estado'],
                                  style: TextStyle(
                                    color: solicitud['estado'] == 'Aceptada'
                                        ? Colors.green[800]
                                        : Colors.orange[800],
                                  ),
                                ),
                              )),
                              DataCell(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Creación: ${solicitud['fechaCreacion']}'),
                                  Text('Actualización: ${solicitud['ultimaActualizacion']}'),
                                ],
                              )),
                              const DataCell(Icon(Icons.file_present, color: Colors.blue)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/estado_solicitud');
                                    },
                                  ),
                                ],
                              )),
                            ]);
                          },
                        ).toList(),
                      ),
                    )
                  : ListView.builder(
                    itemCount: solicitudes.length,
                    itemBuilder: (context, index) {
                      final solicitud = solicitudes[index];
                      final estado = solicitud['estado'] as String;

                      Color estadoColor = Colors.orange[700]!;
                      if (estado == 'Aceptada') estadoColor = Colors.green[700]!;
                      if (estado.contains('Despachado')) estadoColor = const Color(0xFFE77500); // naranjo

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Solicitud #${index + 1}',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text('Tipo    : ',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(solicitud['tipo'],
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Estado : ',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)
                                  ),
                                  Text(
                                    estado,
                                    style: TextStyle(
                                      color: estadoColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Fecha   : ',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)
                                  ),
                                  Text(
                                    'Creación: ${solicitud['fechaCreacion']}\nActualización: ${solicitud['ultimaActualizacion']}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.file_present),
                                    label: const Text('Documento'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE77500), // naranjo USACH
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/estado_solicitud');
                                    },
                                    icon: const Icon(Icons.remove_red_eye),
                                    label: const Text('Acciones'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE77500), // naranjo USACH
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            )
          ],
        ),
      ),
    );
  }
}
