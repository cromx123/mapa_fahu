// models/campus_node.dart
import 'package:latlong2/latlong.dart';

class CampusNode {
  final String id;
  final String tipo;
  final String nombre;
  final String sector;
  final String nivel;
  final LatLng coord;
  final List<Neighbor> vecinos;

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
      coord: LatLng(json['coord']['lat'], json['coord']['lng']),
      vecinos: (json['vecinos'] as List)
          .map((v) => Neighbor.fromJson(v))
          .toList(),
    );
  }
}

class Neighbor {
  final String id;
  final double peso;

  Neighbor({required this.id, required this.peso});

  factory Neighbor.fromJson(Map<String, dynamic> json) {
    return Neighbor(
      id: json['id'],
      peso: json['peso'],
    );
  }
}


List<CampusNode> campusNodes = [];

