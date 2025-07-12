// views/solicitudes_screen.dart
import 'package:flutter/material.dart';

class SolicitudesView extends StatelessWidget {
  const SolicitudesView({super.key});

  final List<Map<String, dynamic>> solicitudes = const [
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
                // Spacer no tiene sentido en Wrap, así que lo quitamos
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/formulario_cae');
                  },
                  child: const Text('Nueva solicitud'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Tipo de solicitud')),
                    DataColumn(label: Text('Estado')),
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Documento conductor')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: solicitudes
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(cells: [
                          DataCell(Text('${entry.key + 1}')),
                          DataCell(Text(entry.value['tipo'])),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              entry.value['estado'],
                              style: TextStyle(color: Colors.green[800]),
                            ),
                          )),
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Creación: ${entry.value['fechaCreacion']}'),
                              Text(
                                  'Actualización: ${entry.value['ultimaActualizacion']}'),
                            ],
                          )),
                          const DataCell(
                            Icon(Icons.file_present, color: Colors.blue),
                          ),
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
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
