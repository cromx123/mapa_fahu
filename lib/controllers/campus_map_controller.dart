// controllers/campus_map_controller.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import '../utils/path_finder.dart';
import '../models/campus_node.dart';

class CampusMapController extends ChangeNotifier {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  LatLng center = LatLng(-33.4467, -70.6821);
  List<Marker> markers = [];
  Marker? userLocationMarker;

  List<LatLng> routePoints = [];

  CampusMapController() {
    _getUserLocation();
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

    if (lugar.id.isNotEmpty && userLocationMarker != null) {
      // Encontrar el nodo más cercano a mi ubicación
      final startNode = campusNodes.reduce((a, b) {
        final da = Distance().as(LengthUnit.Meter, a.coord, userLocationMarker!.point);
        final db = Distance().as(LengthUnit.Meter, b.coord, userLocationMarker!.point);
        return da < db ? a : b;
      });

      final path = dijkstra(campusNodes, startNode.id, lugar.id);
      routePoints = path.map((n) => n.coord).toList();

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

      center = lugar.coord;
      notifyListeners();
      mapController.move(lugar.coord, 17);
    }
  }

  void moveToUserLocation() => _getUserLocation(moveToLocation: true);
}
