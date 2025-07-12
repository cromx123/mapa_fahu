import 'package:flutter/material.dart';
import 'package:maps_fahu/controllers/campus_map_controller.dart';
import 'package:provider/provider.dart';


class PlaceInfoCard extends StatelessWidget {
  const PlaceInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CampusMapController>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del lugar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nombre: ${controller.selectedPlaceName.isNotEmpty ? controller.selectedPlaceName : 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Piso: ${controller.selectedPlaceFloor.isNotEmpty ? controller.selectedPlaceFloor : 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Sector: ${controller.selectedPlaceSector.isNotEmpty ? controller.selectedPlaceSector : 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Tipo: ${controller.selectedPlaceType.isNotEmpty ? controller.selectedPlaceType : 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline_rounded, color: Colors.deepOrange),
              onPressed: () {
                // Aquí puedes poner una acción como mostrar más info
              },
            ),
          ],
        ),
      ),
    );
  }
}
