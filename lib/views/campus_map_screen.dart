// views/campus_map_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../controllers/campus_map_controller.dart';
import '../controllers/mic_controller.dart';
import 'menu_screen.dart';
import '../widgets/info_card.dart';
import 'package:humanidades360/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';


class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CampusMapController>(context);
    final micController = Provider.of<MicController>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;
    final searchController = controller.searchController;

    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = kIsWeb || screenWidth > 800;

    return Scaffold(
      body: isLargeScreen
          ? Row(
              children: [
                if (controller.routePoints.isNotEmpty)
                  const SizedBox(
                    child: PlaceInfoCard(),
                  ),
                Expanded(
                  flex: 3,
                  child: buildMapWithControls(
                    context, controller, micController, localizations, searchController,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                buildMapWithControls(
                  context, controller, micController, localizations, searchController,
                ),
                if (controller.routePoints.isNotEmpty && controller.isInfoCardVisible)
                  Positioned(
                    bottom: 0,
                    child: PlaceInfoCard(),
                  ),
              ],
            ),
    );
  }

  Widget buildMapWithControls(
    BuildContext context,
    CampusMapController controller,
    MicController micController,
    AppLocalizations localizations,
    TextEditingController searchController,
  ) {

    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = kIsWeb || screenWidth > 800;
    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            mapController: controller.mapController,
           options: MapOptions(
             initialCenter: LatLng(-33.447343, -70.684989), // Punto central del campus
             initialZoom: 17,
             minZoom: 15,
             maxZoom: 22,
            cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
             LatLng(-33.453011, -70.688118), // esquina suroeste
             LatLng(-33.444813, -70.679414), // esquina noreste
              ),
             ),
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
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              MarkerLayer(markers: [
                if (controller.userLocationMarker != null)
                  controller.userLocationMarker!,
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
              buildTopControls(
                context, micController, controller, localizations, searchController,
              ),
              const SizedBox(height: 8),
              buildFilterChips(context, controller, localizations, searchController),
            ],
          ),
        ),
        Positioned(
          bottom: isLargeScreen
          ? 20 
          : (controller.routePoints.isNotEmpty
           ? (controller.isCollapse ? 90 : 150) : 20),
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            onPressed: controller.moveToUserLocation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100), // muy grande para que quede redondo
              side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1),
            ),
            child: Icon(Icons.my_location, color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
          ),
        ),
      ], 
    );
  }

  Widget buildTopControls(
    BuildContext context,
    MicController micController,
    CampusMapController controller,
    AppLocalizations localizations,
    TextEditingController searchController,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: theme.shadowColor.withOpacity(0.2), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: theme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: micController.searchController,
              style: theme.textTheme.bodyMedium,
              onSubmitted: controller.buscarLugar,
              decoration: InputDecoration(
                hintText: localizations.cms_searchHint,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              micController.isListening ? micController.stopListening() : micController.startListening();
            },
            icon: Icon(
              micController.isListening ? Icons.mic : Icons.mic_none,
              color: theme.primaryColor,
            ),
            tooltip: localizations.cms_voiceSearchTooltip,
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
            icon: Icon(Icons.menu, color: theme.primaryColor),
            tooltip: localizations.cms_openMenuTooltip,
          ),
        ],
      ),
    );
  }

  Widget buildFilterChips(
    BuildContext context,
    CampusMapController controller,
    AppLocalizations localizations,
    TextEditingController searchController,
  ) {
    final filters = [
      {'label': localizations.cms_filterLibraries, 'query': 'Biblioteca Química y Biología'},
      {'label': localizations.cms_filterCasinos, 'query': 'Casinos'},
      {'label': localizations.cms_filterBathrooms, 'query': 'Facultad de Humanidades'},
      {'label': localizations.cms_filterOthers, 'query': 'otros'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter['label']!,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              selected: false,
              onSelected: (_) {
                searchController.text = filter['query']!;
                controller.buscarLugar(searchController.text);
              },
              backgroundColor: Theme.of(context).cardColor,
              elevation: 2,
              shadowColor: Theme.of(context).shadowColor,
              side: BorderSide(color: Colors.grey.withOpacity(0.8), width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
