// utils/path_finder.dart
import '../models/campus_node.dart';

class PathResult {
  final List<CampusNode> path;
  final double distance;

  PathResult(this.path, this.distance);
}

PathResult dijkstra(
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

    for (final neighbor in currentNode.vecinos) {
      final neighborId = neighbor.id;
      if (!unvisited.contains(neighborId)) continue;

      final double alt = dist[currentId]! + neighbor.peso;

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

  final double totalDistance = dist[goalId]!;

  return PathResult(path, totalDistance);
}
