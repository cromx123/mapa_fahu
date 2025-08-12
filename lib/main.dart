import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:humanidades360/l10n/app_localizations.dart';
import 'package:humanidades360/views/convocatorias_screen.dart';
import 'package:provider/provider.dart';
import 'controllers/settings_controller.dart';
import 'controllers/campus_map_controller.dart';
import 'controllers/mic_controller.dart';
import 'views/login_screen.dart';
import 'views/menu_screen.dart';
import 'views/config_screen.dart';
import 'views/servicios_screen.dart';
import 'views/solicitudes_screen.dart';
import 'views/formulario_cae.dart';
import 'views/estado_sol_screen.dart';
import '/views/foto_screen.dart';
import 'themes/theme.dart';
import 'animated_splash_screen.dart';
import 'views/feedback_screen.dart';

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
        ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: const CampusMapApp(),
    ),
  );
}

class CampusMapApp extends StatelessWidget {
  const CampusMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Provider.of<SettingsController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa del Campus',
      locale: localeController.locale,
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: localeController.themeMode,
      home: const AnimatedSplashScreen(),
      routes: {
        '/menu_screen': (context) => const MenuScreen(),
        '/config_screen': (context) => const ConfigScreen(),
        '/servicios_screen': (context) => const ServiciosScreen(),
        '/solicitudes_screen': (context) => const SolicitudesView(),
        '/login_screen': (context) =>  const LoginPage(),
        '/convocatorias_screen': (context) => const ConvocatoriasScreen(),
        '/formulario_cae': (context) {final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
          return FormularioHtmlScreen(
            base64LogoHeader: args?['logoHeader'] ?? '',
            base64LogoFooter: args?['logoFooter'] ?? '',
          );
        },
        '/estado_solicitud': (context) => const EstadosSolicitudesScreen(),
        '/feedback_screen': (context) => const FeedbackScreen(),
        '/foto_screen'     : (context) => FotoScreen(),
      },
    );
  }
}