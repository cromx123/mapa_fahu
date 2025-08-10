// lib/widgets/info_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:humanidades360/controllers/campus_map_controller.dart';

class PlaceInfoCard extends StatefulWidget {
  const PlaceInfoCard({super.key});

  @override
  State<PlaceInfoCard> createState() => _PlaceInfoCardState();
}

class _PlaceInfoCardState extends State<PlaceInfoCard> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CampusMapController>();
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = kIsWeb || screenWidth > 800;
    final collapsedWidth  = isLargeScreen ? 70.0 : screenWidth;
    final expandedWidth   = isLargeScreen ? 320.0 : screenWidth;
    final collapsedHeight = isLargeScreen ? screenHeight : 70.0;
    final expandedHeight  = isLargeScreen ? screenHeight : screenWidth * 0.4;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          setState(() => isCollapsed = true);
          controller.hideInfoCard();
        } else if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          setState(() => isCollapsed = false);
          controller.showInfoCard();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isCollapsed ? collapsedWidth : expandedWidth,
        height: isCollapsed ? collapsedHeight : expandedHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: isLargeScreen
              ? BorderRadius.circular(0)
              : const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
          boxShadow: [
            BoxShadow(color: theme.shadowColor.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: Stack(
          children: [
            if (kIsWeb)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(isCollapsed ? Icons.arrow_forward_ios : Icons.close),
                  color: theme.iconTheme.color,
                  onPressed: () => setState(() => isCollapsed = !isCollapsed),
                ),
              )
            else
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 4, width: 64,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            if (controller.isNavigationActive)
              Positioned.fill(
  child: Padding(
    padding: EdgeInsets.only(
      top: kIsWeb ? 40 : 8,
      left: 16,
      right: 16,
      bottom: 12,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        StreamBuilder<int>(
          stream: Stream.periodic(const Duration(seconds: 20), (_) => DateTime.now().millisecondsSinceEpoch),
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.tiempoEstimadoLabel,
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.distanciaLabel} · ${controller.etaLabel}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                  ),
                ),
              ],
            );
          },
        ),

        const Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: controller.stopNavigation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Salir', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    ),
  ),
)
            else
              Padding(
                padding: EdgeInsets.only(top: kIsWeb ? 40 : 8, right: 72), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    if (!isCollapsed) ...[
                      const Text('Información del lugar',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                    ],
                    if (!isLargeScreen)
                      Text(
                        '${isCollapsed ? '' : 'Nombre: '}${controller.selectedPlaceName.isNotEmpty ? controller.selectedPlaceName : 'N/A'}',
                        style: isCollapsed
                            ? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                            : const TextStyle(fontSize: 16),
                      )
                    else
                      Text(
                        'Nombre: ${controller.selectedPlaceName.isNotEmpty ? controller.selectedPlaceName : 'N/A'}',
                      ),
                    Visibility(
                      visible: !isCollapsed,
                      child: AnimatedOpacity(
                        opacity: !isCollapsed ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Piso: ${controller.selectedPlaceFloor.isNotEmpty ? controller.selectedPlaceFloor : 'N/A'}'),
                            Text('Sector: ${controller.selectedPlaceSector.isNotEmpty ? controller.selectedPlaceSector : 'N/A'}'),
                            Text('Tipo: ${controller.selectedPlaceType.isNotEmpty ? controller.selectedPlaceType : 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!controller.isNavigationActive && controller.routePoints.isNotEmpty)
              Positioned(
                right: 8,
                bottom: 12,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'navFabInsideCard',
                      onPressed: controller.toggleNavigation, 
                      backgroundColor: theme.colorScheme.primary,
                      child: const Icon(Icons.navigation),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Iniciar',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
