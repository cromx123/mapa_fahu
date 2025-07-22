import 'package:flutter/material.dart';
import '/views/campus_map_screen.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fahuController;
  late final AnimationController _xController;

  late final Animation<double> _fadeFahu;
  late final Animation<double> _fadeX;

  bool showX = false;

  @override
  void initState() {
    super.initState();

    _fahuController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeFahu = CurvedAnimation(parent: _fahuController, curve: Curves.easeIn);
    _fadeX = CurvedAnimation(parent: _xController, curve: Curves.easeIn);

    _fahuController.forward();

    // Mostrar X después de 3 segundos
    Future.delayed(const Duration(seconds: 6), () {
      setState(() => showX = true);
      _xController.forward();
    });

    // Ir a siguiente pantalla después de todo
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CampusMapScreen()),
      );
    });
  }

  @override
  void dispose() {
    _fahuController.dispose();
    _xController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7C898), // Fondo pastel anaranjado
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: _fadeFahu,
              child: Visibility(
                visible: !showX,
                child: Image.asset(
                  'assets/images/fahu.png',
                  width: 250,
                ),
              ),
            ),
            FadeTransition(
              opacity: _fadeX,
              child: Visibility(
                visible: showX,
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
