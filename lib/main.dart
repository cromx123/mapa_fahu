import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/campus_map_controller.dart';
import 'controllers/mic_controller.dart';
import 'views/campus_map_screen.dart';
import 'views/menu_screen.dart';
import 'views/config_screen.dart';
import 'views/servicios_screen.dart';
import 'views/solicitudes_screen.dart';
import 'views/formulario_cae.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CampusMapController()),
        ChangeNotifierProxyProvider<CampusMapController, MicController>(
          create: (context) => MicController(context.read<CampusMapController>()),
          update: (context, campusMapController, previousMicController) =>
              previousMicController!..updateController(campusMapController),
        ),
      ],
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
        '/servicios_screen': (context) => const ServiciosScreen(),
        '/solicitudes_screen': (context) => const SolicitudesView(),
        '/formulario_cae': (context) => const FormularioHtmlScreen(),
      },
    );
  }
}