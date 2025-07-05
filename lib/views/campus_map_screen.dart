import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../controllers/campus_map_controller.dart';
import 'menu_screen.dart';

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CampusMapController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del Campus'),
        backgroundColor: const Color.fromARGB(255, 0, 163, 152),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.searchController,
                  onSubmitted: controller.buscarLugar,
                  decoration: InputDecoration(
                    hintText: 'Buscar lugar...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Expanded(
                child: FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: controller.center,
                    initialZoom: 17,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.campusmap',
                    ),
                    if (controller.routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: controller.routePoints,
                            strokeWidth: 4,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    MarkerLayer(markers: [
                      if (controller.userLocationMarker != null) controller.userLocationMarker!,
                      ...controller.markers,
                    ]),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: controller.moveToUserLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
