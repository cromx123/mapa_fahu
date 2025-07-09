import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../controllers/campus_map_controller.dart';
import '../controllers/mic_controller.dart';
import 'menu_screen.dart';
import '../widgets/info_card.dart';

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CampusMapController>(context);
    final micController = Provider.of<MicController>(context, listen: false);
    final TextEditingController searchController = controller.searchController;
    

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
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
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: micController.searchController,
                                onSubmitted: controller.buscarLugar,
                                decoration: InputDecoration(
                                  hintText: 'Buscar lugar...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed: (){ micController.isListening ? micController.stopListening() : micController.startListening();},
                              icon: Icon(micController.isListening ? Icons.mic : Icons.mic_none, color: Colors.teal),
                              tooltip: 'Buscar por voz',
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (_, __, ___) => const MenuScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.menu, color: Colors.teal),
                              tooltip: 'Abrir menú',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Filtros 
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Bibliotecas', style: TextStyle(color: Colors.black , fontSize: 12, fontWeight: FontWeight.bold)),
                        selected: false,
                        onSelected: (_){
                          searchController.text = 'Bibliotecas';
                          controller.buscarLugar(searchController.text);
                        },
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.black26,
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.8),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Casinos', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                        selected: false,
                        
                        onSelected: (_){
                          searchController.text = 'Casinos';
                          controller.buscarLugar(searchController.text);
                        },
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.black26,
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.8),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Baños', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                        selected: false,
                        onSelected: (_){
                          searchController.text = 'Facultad de Humanidades';
                          controller.buscarLugar(searchController.text);
                        },
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.black26,
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.8),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('otros...', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                        selected: false,
                        onSelected: (_){
                          searchController.text = 'otros';
                          controller.buscarLugar(searchController.text);
                        },
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.black26,
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.8),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          if (controller.routePoints.isNotEmpty) ...[
            const PlaceInfoCard(),
            Positioned(
              bottom: 130,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                onPressed: controller.moveToUserLocation,
                child: const Icon(Icons.my_location),
              ),
            ),
          ] else
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                onPressed: controller.moveToUserLocation,
                child: const Icon(Icons.my_location),
              ),
            ),
        ],
      ),
    );
  }
}
