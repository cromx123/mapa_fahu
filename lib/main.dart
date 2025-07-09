import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/campus_map_controller.dart';
import 'views/campus_map_screen.dart';
import 'views/menu_screen.dart';
import 'views/config_screen.dart';

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
      routes: {
        '/menu_screen': (context) => const MenuScreen(),
        '/config_screen': (context) => const ConfigScreen(),
      },
    );
  }
}
