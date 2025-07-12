// controllers/campus_map_controller.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import '../utils/path_finder.dart';
import '../models/campus_node.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class CampusMapController extends ChangeNotifier {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  LatLng center = LatLng(-33.4467, -70.6821);
  List<Marker> markers = [];
  Marker? userLocationMarker;

  List<LatLng> routePoints = [];
  double distancia = 0.0;
  double distanciaKm = 0.0;
  double tiempoMinutos = 0.0;
  double tiempoHoras = 0.0;
  final double velocidadPromedio = 5.0; // Velocidad promedio en k/h
  String selectedPlaceName = '';
  String selectedPlaceFloor = '';
  String selectedPlaceSector = '';
  String selectedPlaceType = '';

  CampusMapController() {
    loadNodes();
    _getUserLocation();
  }
  Future<void> loadNodes() async {
    final String jsonString = await rootBundle.loadString('assets/data/nodes.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    campusNodes = jsonData.map((item) => CampusNode.fromJson(item)).toList();
    notifyListeners();
  }
  Future<void> _getUserLocation({bool moveToLocation = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(position.latitude, position.longitude);

    userLocationMarker = Marker(
      point: userLatLng,
      width: 40,
      height: 40,
      child: const Icon(Icons.person_pin_circle, size: 40, color: Colors.blue),
    );
    center = userLatLng;
    notifyListeners();

    if (moveToLocation) {
      mapController.move(userLatLng, 17);
    }
  }

  void buscarLugar(String texto) {
    final lugar = campusNodes.firstWhere(
      (n) => n.nombre.toLowerCase().contains(texto.toLowerCase()),
      orElse: () => CampusNode(
          id: '', tipo: '', nombre: '', sector: 0, nivel: 1, coord: LatLng(0,0), vecinos: []),
    );
    
    selectedPlaceName = lugar.nombre;
    selectedPlaceFloor = lugar.nivel.toString();
    selectedPlaceSector = lugar.sector.toString();
    selectedPlaceType = lugar.tipo;

    if (lugar.id.isNotEmpty && userLocationMarker != null) {
      // Encontrar el nodo más cercano a mi ubicación
      final startNode = campusNodes.reduce((a, b) {
        final da = Distance().as(LengthUnit.Meter, a.coord, userLocationMarker!.point);
        final db = Distance().as(LengthUnit.Meter, b.coord, userLocationMarker!.point);
        return da < db ? a : b;
      });

      final resutlt = dijkstra(campusNodes, startNode.id, lugar.id);
      routePoints = resutlt.path.map((n) => n.coord).toList();
      distancia = resutlt.distance ;
      distanciaKm = distancia / 1000; // Convertir a kilómetros
      tiempoHoras = distanciaKm / velocidadPromedio;
      tiempoMinutos = tiempoHoras * 60; // Convertir a minutos

      // Si userLocationMarker existe, añade primero tu ubicación real
      if (userLocationMarker != null) {
        routePoints.insert(0, userLocationMarker!.point);
      }

      markers = [
        Marker(
          point: lugar.coord,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
        )
      ];

      final labelPoint = LatLng(lugar.coord.latitude + 0.0002, lugar.coord.longitude + 0.0006);

      markers.add(
        Marker(
          point: labelPoint,
          width: 100, 
          height: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.only( bottomLeft: Radius.circular(0), bottomRight: Radius.circular(12), topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_walk, color: Colors.grey, size: 14),
                    Text(
                      '${tiempoMinutos.toStringAsFixed(2)} min',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                
                Text(
                  '${distancia.toStringAsFixed(0)} mts',

                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
      center = lugar.coord;
      notifyListeners();
      mapController.move(lugar.coord, 17);
    }
  }

  void moveToUserLocation() => _getUserLocation(moveToLocation: true);
}
