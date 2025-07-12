// views/solicitudes_screen.dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SolicitudesView(),
    debugShowCheckedModeBanner: false,
  ));
}

class SolicitudesView extends StatelessWidget {
  final List<Map<String, dynamic>> solicitudes = [
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
      appBar: AppBar(title: Text('Solicitudes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: 'Primer semestre del año 2025',
                  items: [
                    DropdownMenuItem(
                      child: Text('Primer semestre del año 2025'),
                      value: 'Primer semestre del año 2025',
                    ),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Filtrar'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Nueva solicitud'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
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
                            padding: EdgeInsets.symmetric(
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
                          DataCell(
                            Icon(Icons.file_present, color: Colors.blue),
                          ),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {},
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
