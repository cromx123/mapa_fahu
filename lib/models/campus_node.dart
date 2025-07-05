// models/campus_node.dart
import 'package:latlong2/latlong.dart';

class CampusNode {
  final String id; 
  final String tipo; // sala, edificio, camino, baño...
  final String nombre;
  final int sector;
  final int nivel; // opcional, para edificios con varios niveles
  final LatLng coord;
  final List<String> vecinos; // ids de nodos vecinos

  CampusNode({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.sector,
    required this.nivel,
    required this.coord,
    required this.vecinos,
  });

  factory CampusNode.fromJson(Map<String, dynamic> json) {
    return CampusNode(
      id: json['id'],
      tipo: json['tipo'],
      nombre: json['nombre'],
      sector: json['sector'],
      nivel: json['nivel'],
      coord: LatLng(
        json['coord']['lat'],
        json['coord']['lng'],
      ),
      vecinos: List<String>.from(json['vecinos']),
    );
  }
}

List<CampusNode> campusNodes = [];

