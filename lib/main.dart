import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/campus_map_controller.dart';
import 'views/campus_map_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CampusMapController(),
      child: const CampusMapApp(),
    ),
  );
}

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
