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
}

final List<CampusNode> campusNodes = [
  CampusNode(
    id: 'n1',
    tipo: 'entrada',
    nombre: 'Entrada Principal',
    sector: 0,
    nivel: 1, // Nivel opcional para entradas
    coord: LatLng(-33.4460, -70.6820),
    vecinos: ['n2', 'n3'],
  ),
  CampusNode(
    id: 'n2',
    tipo: 'edificio',
    nombre: 'Biblioteca',
    sector: 1,
    nivel: 1, // Nivel opcional para edificios
    coord: LatLng(-33.4462, -70.6810),
    vecinos: ['n1', 'n4'],
  ),
  CampusNode(
    id: 'n3',
    tipo: 'edificio',
    nombre: 'Facultad de Humanidades',
    sector: 2,
    nivel: 1, // Nivel opcional para edificios
    coord: LatLng(-33.448183, -70.682983),
    vecinos: ['n1', 'n4'],
  ),
  CampusNode(
    id: 'n4',
    tipo: 'camino',
    nombre: 'Patio Central',
    sector: 1,
    nivel: 1, // Nivel opcional para caminos
    coord: LatLng(-33.4465, -70.6815),
    vecinos: ['n2', 'n3'],
  ),
];
