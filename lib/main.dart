// main.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const CampusMapApp());

class CampusMapApp extends StatelessWidget {
  const CampusMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa del Campus',
      home: const CampusMapScreen(),
    );
  }
}

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  LatLng _center = LatLng(-33.4467, -70.6821); // Default to USACH
  Marker? _userLocationMarker;

  final Map<String, LatLng> lugares = {
    'Facultad de Humanidades': LatLng(-33.4467, -70.6821),
    'Biblioteca Central': LatLng(-33.4462, -70.6810),
  };

  @override
  void initState() {
    super.initState();
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

    setState(() {
      _center = userLatLng;
      _userLocationMarker = Marker(
        point: userLatLng,
        width: 40,
        height: 40,
        child: const Icon(Icons.person_pin_circle, size: 40, color: Colors.blue),
      );
    });

    if (moveToLocation) {
      _mapController.move(userLatLng, 17);
    }
  }

  void _buscarLugar(String texto) {
    final lugar = lugares.entries
        .firstWhere((e) => e.key.toLowerCase().contains(texto.toLowerCase()), orElse: () => const MapEntry('', LatLng(0, 0)));

    if (lugar.key != '') {
      setState(() {
        _markers = [
          Marker(
            point: lugar.value,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
          )
        ];
        _center = lugar.value;
      });
      _mapController.move(lugar.value, 17);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => const MenuScreen()),
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
                  controller: _searchController,
                  onSubmitted: _buscarLugar,
                  decoration: InputDecoration(
                    hintText: 'Buscar lugar...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 17,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.campusmap',
                    ),
                    MarkerLayer(markers: [
                      if (_userLocationMarker != null) _userLocationMarker!,
                      ..._markers,
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
              onPressed: () => _getUserLocation(moveToLocation: true),
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true, // evita scroll interno
                      physics: const NeverScrollableScrollPhysics(), // evita conflictos de scroll
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: const [
                        MenuItem(icon: Icons.school, label: 'Portal Usach', url: 'https://www.usach.cl/'),
                        MenuItem(icon: Icons.person, label: 'Portal\naAlumnos', url: 'https://registro.usach.cl/index.php'),
                        MenuItem(icon: Icons.visibility, label: 'Servicios\nEn línea', url: 'https://www.serviciosweb.usach.cl/login'),
                        MenuItem(icon: Icons.menu_book, label: 'Biblioteca', url: 'https://biblioteca.usach.cl/'),
                        MenuItem(icon: Icons.headset_mic, label: 'Usach\nAtiende'),
                        MenuItem(icon: Icons.notifications, label: 'Notificaciones'),
                        MenuItem(icon: Icons.settings, label: 'Configuración'),
                        MenuItem(icon: Icons.help_outline, label: 'Ayuda'),
                        MenuItem(icon: Icons.info, label: 'Información'),
                        MenuItem(icon: Icons.logout, label: 'Cerrar sesión'),
                        MenuItem(), MenuItem(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '© 2025 Cromx && Gabo && Fahu\nversión 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final String? url;

  const MenuItem({super.key, this.icon, this.label, this.url});

  void _launchURL(BuildContext context) async {
    if (url == null) return;

    final uri = Uri.parse(url!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: icon != null && label != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30, color: Colors.black),
                  const SizedBox(height: 8),
                  Text(
                    label!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}