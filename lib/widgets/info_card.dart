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
    final controller = Provider.of<CampusMapController>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = kIsWeb || screenWidth > 800;

    // ancho según estado
    final collapsedWidth = isLargeScreen ? 70.0 :screenWidth;
    final expandedWidth = isLargeScreen ? 320.0 : screenWidth;

    final collapsedHeight = isLargeScreen ? screenHeight: 70.0;
    final expandedHeight = isLargeScreen ? screenHeight : screenWidth * 0.4;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          setState(() {
            isCollapsed = true;

          });
          controller.hideInfoCard();
        } else if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          setState(() {
            isCollapsed = false;
          });
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
          color: Theme.of(context).cardColor,
          borderRadius: isLargeScreen ? BorderRadius.circular(0) : BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0),),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            if (kIsWeb)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(isCollapsed ? Icons.arrow_forward_ios : Icons.close),
                  color: Theme.of(context).iconTheme.color,
                  onPressed: () {
                    setState(() {
                      isCollapsed = !isCollapsed;
                    });
                  },
                ),
              ),
            if (!kIsWeb)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 4,
                  width: 64,
                  decoration: 
                    BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                ),
              ),
            // Contenido solo si no está colapsado
              Padding(
                padding: const EdgeInsets.only(top: kIsWeb ? 40 : 0), // deja espacio para el botón en web
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    if (!isCollapsed) ...[
                      const Text('Información del lugar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                    ],
                    if (!isCollapsed && isLargeScreen)
                      Text('Nombre: ${controller.selectedPlaceName.isNotEmpty ? controller.selectedPlaceName : 'N/A'}',),
                    if (!isLargeScreen)
                      Text(
                            '${isCollapsed? '':'Nombre: '}${controller.selectedPlaceName.isNotEmpty ? controller.selectedPlaceName : 'N/A'}',
                            style: isCollapsed? TextStyle(fontSize: 18, fontWeight: FontWeight.bold): TextStyle(fontSize: 16),
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
          ],
        ),
      )
    );
  }
}
