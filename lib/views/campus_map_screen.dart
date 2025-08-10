import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../controllers/campus_map_controller.dart';
import '../controllers/mic_controller.dart';
import 'menu_screen.dart';
import '../widgets/info_card.dart';
import '../widgets/heading_triangle.dart';
import 'package:humanidades360/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

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
                  const Positioned(
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
              initialCenter: const LatLng(-33.447343, -70.684989),
              initialZoom: 17,                 
              minZoom: 1,
              maxZoom: 25,
              cameraConstraint: const CameraConstraint.unconstrained(), 
              onMapEvent: controller.onMapEvent, 
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.campusmap',
                maxNativeZoom: 19,
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
              CurrentLocationLayer(
              positionStream: controller.locStream,
              headingStream: controller.headingStream,
              style: const LocationMarkerStyle(
              marker: UsachinHeadingMarker(),
              markerSize: Size(100,100),
              markerDirection: MarkerDirection.heading,
              headingSectorColor: Colors.transparent,
              accuracyCircleColor: Colors.transparent,
             ),
            ),
              MarkerLayer(markers: controller.markers),
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
              _buildTopControls(
                context, micController, controller, localizations, searchController,
              ),
              const SizedBox(height: 8),
              _buildFilterChips(context, controller, localizations, searchController),
            ],
          ),
        ),
        Positioned(
          bottom: isLargeScreen
              ? 20
              : (controller.routePoints.isNotEmpty
                  ? (controller.isCollapse ? 90 : 150)
                  : 20),
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            onPressed: controller.moveToUserLocation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.my_location,
              color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopControls(
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
  child: Autocomplete<String>(
  
    optionsBuilder: (TextEditingValue tev) {
    final q = tev.text.trim();
    if (q.isEmpty) {
    
    return controller.suggestions.take(12);
    }
    return controller.filterSuggestions(q, limit: 12);
    },

   
    onSelected: (String value) {
      controller.searchController.text = value;
      controller.buscarYRutarDesdeBackend(value);
    },

    fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
      controller.searchController.value = textController.value;
      textController.addListener(() {
        controller.searchController.value = textController.value;
      });

      return TextField(
        controller: textController,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.bodyMedium,
        onSubmitted: controller.buscarYRutarDesdeBackend,
        decoration: InputDecoration(
          hintText: localizations.cms_searchHint,
          border: InputBorder.none,
        ),
      );
    },

    optionsViewBuilder: (context, onSelected, options) {
      final opts = options.toList();

      return Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 64,
              maxHeight: 280,
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: opts.length,
              itemBuilder: (context, index) {
                final opt = opts[index];
                return InkWell(
                  onTap: () => onSelected(opt),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10,
                    ),
                    child: Text(
                      opt,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
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

  Widget _buildFilterChips(
    BuildContext context,
    CampusMapController controller,
    AppLocalizations localizations,
    TextEditingController searchController,
  ) {
    String? selectedFilter;

    final filters = [
      {'label': localizations.cms_filterLibraries, 'query': 'biblioteca'},
      {'label': localizations.cms_filterCasinos, 'query': 'casino'},
      {'label': localizations.cms_filterBathrooms, 'query': 'baño'},
      {'label': localizations.cms_filterRooms, 'query': 'sala'},
      {'label': localizations.cms_filterOthers, 'query': 'otros'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter['query'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter['label']!,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                selectedFilter = isSelected ? null : filter['query'];
                searchController.text = selectedFilter ?? '';
                controller.mostrar_busqueda(searchController.text);
              },
              backgroundColor: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              elevation: 2,
              shadowColor: Theme.of(context).shadowColor,
              side: BorderSide(color: Colors.grey.withOpacity(0.8), width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }).toList(),
      ),
    );
  }
}
