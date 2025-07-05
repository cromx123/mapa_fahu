// utils/path_finder.dart
import 'package:latlong2/latlong.dart';
import '../models/campus_node.dart';

List<CampusNode> dijkstra(
  List<CampusNode> nodes,
  String startId,
  String goalId,
) {
  final Map<String, double> dist = {};
  final Map<String, String?> prev = {};

  for (var node in nodes) {
    dist[node.id] = double.infinity;
    prev[node.id] = null;
  }

  dist[startId] = 0;
  final unvisited = Set<String>.from(nodes.map((n) => n.id));

  while (unvisited.isNotEmpty) {
    final currentId = unvisited.reduce((a, b) => dist[a]! < dist[b]! ? a : b);
    unvisited.remove(currentId);

    if (currentId == goalId) break;

    final currentNode = nodes.firstWhere((n) => n.id == currentId);
    for (final neighborId in currentNode.vecinos) {
      if (!unvisited.contains(neighborId)) continue;

      final neighborNode = nodes.firstWhere((n) => n.id == neighborId);
      final double alt = dist[currentId]! +
          Distance().as(LengthUnit.Meter, currentNode.coord, neighborNode.coord);

      if (alt < dist[neighborId]!) {
        dist[neighborId] = alt;
        prev[neighborId] = currentId;
      }
    }
  }

  // Reconstruir ruta
  final path = <CampusNode>[];
  String? u = goalId;
  while (u != null) {
    final node = nodes.firstWhere((n) => n.id == u);
    path.insert(0, node);
    u = prev[u];
  }

  return path;
}
