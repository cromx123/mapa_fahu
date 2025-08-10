// controllers/campus_map_controller.dart
import 'dart:math';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:diacritic/diacritic.dart';

const String baseUrl = "http://172.24.63.31:8000";


class CampusMapController extends ChangeNotifier {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  final logger = Logger();
  final double deviationThresholdM = 0.5;   
  final double velocidadPromedio = 5.0; 
  final Duration _rerouteCooldown = const Duration(seconds: 6);
  final _posCtrl = StreamController<LocationMarkerPosition?>.broadcast();
  final _headingCtrl = StreamController<LocationMarkerHeading?>.broadcast();

  LatLng center = LatLng(-33.4467, -70.6821);
  List<Marker> markers = [];
  Marker? userLocationMarker;
  List<String> _sugg = [];
  bool _suggLoaded = false;
  List<LatLng> routePoints = [];
  double distancia = 0.0;
  double distanciaKm = 0.0;
  double tiempoMinutos = 0.0;
  double tiempoHoras = 0.0;
  String selectedPlaceName = '';
  String selectedPlaceFloor = '';
  String selectedPlaceSector = '';
  String selectedPlaceType = '';
  bool isInfoCardVisible = false;
  bool isCollapse = false;
  String selectedPlaceId = '';
  StreamSubscription<Position>? _posSub;   
  Timer? _routeDebounce;                   
  bool _followUser = false;
  StreamSubscription<Position>? _gpsSub;
  StreamSubscription<AccelerometerEvent>? _accSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  StreamSubscription<CompassEvent>? _magSub;
  double? lastAccuracyM;
  DateTime? _lastRerouteTs;
  bool get isFollowing => _followUser;
  bool hardLockCenterWhileFollowing = true;
  Stream<LocationMarkerPosition?> get locStream => _posCtrl.stream;
  Stream<LocationMarkerHeading?> get headingStream => _headingCtrl.stream;
  double get headingDeg => _headingRad * 180.0 / pi;
  String _norm(String s) => removeDiacritics(s).toLowerCase().trim();
  double _headingRad = 0.0;  
  List<String> get suggestions => _sugg;   
  DateTime? _lastGyroTs;
  bool isNavigationActive = false;
  LatLng? _posEstimada;         
  double _stepLength = 0.75;    
  int _stepCounter = 0;
  DateTime? _etaDate;
  String get tiempoEstimadoLabel => '${remainingMinutes} min';
  bool _isMovingProgrammatically = false;


  CampusMapController() {
  initFusion();
  loadSuggestionsFromBackend();
  }

  Future<void> _getUserLocation({bool moveToLocation = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(position.latitude, position.longitude);

    userLocationMarker = Marker(
      point: userLatLng,
      width: 40,
      height: 40,
      child: const Icon(Icons.person_pin_circle, size: 40, color: Colors.blue),
    );
    center = userLatLng;
    notifyListeners();

    if (moveToLocation) {
    _safeMove(userLatLng, 17);
    }

  }

Future<void> loadSuggestionsFromBackend() async {
  if (_suggLoaded) return;
  try {
    final uri = Uri.parse("$baseUrl/sugerencias");
    final r = await http.get(uri, headers: {'Accept': 'application/json'});
    if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}');

    final j = jsonDecode(utf8.decode(r.bodyBytes));
    if (j is! List) throw Exception('Se esperaba una lista JSON');

    final seen = <String>{};
    _sugg = [for (final e in j) if (e != null && seen.add('$e')) '$e'];

    _suggLoaded = true;
    notifyListeners();
  } catch (e) {
    debugPrint('Fallo cargando sugerencias desde backend: $e');
    _sugg = [];
    _suggLoaded = true;
    notifyListeners();
  }
}


List<String> filterSuggestions(String query, {int limit = 10}) {
  final q = _norm(query);
  if (q.isEmpty || _sugg.isEmpty) return const [];

  final starts = <String>[];
  final contains = <String>[];

  for (final s in _sugg) {
    final n = _norm(s);
    if (n.contains(q)) {
      if (n.startsWith(q) || n.split(' ').any((w) => w.startsWith(q))) {
        starts.add(s);
      } else {
        contains.add(s);
      }
    }
    if (starts.length + contains.length >= limit) break;
  }
  return [...starts, ...contains].take(limit).toList();
}

void onMapEvent(MapEvent evt) {
  if (_isMovingProgrammatically) return;   
  if (!_followUser) return;               

  if (hardLockCenterWhileFollowing) {
    if (userLocationMarker != null) {
      final z = isNavigationActive ? 19.0 : mapController.camera.zoom;
      final rot = isNavigationActive ? mapController.camera.rotation : null;
      _safeMove(userLocationMarker!.point, z, rotation: rot);
    }
    return; 
  }

  _followUser = false;
  notifyListeners();
}



void startNavigation() {
  if (routePoints.isEmpty || selectedPlaceId.isEmpty) return;
  isNavigationActive = true;
  _followUser = true;

  if (userLocationMarker != null) {
    final rot = mapController.camera.rotation;
    _safeMove(userLocationMarker!.point, 25.0, rotation: rot);
  }

  notifyListeners();
}


void _safeMove(LatLng center, double zoom, {double? rotation}) {
  _isMovingProgrammatically = true;
  try {
    if (rotation != null) {
      mapController.moveAndRotate(center, zoom, rotation);
    } else {
      mapController.move(center, zoom);
    }
  } finally {

    Future.delayed(const Duration(milliseconds: 80), () {
      _isMovingProgrammatically = false;
    });
  }
}



int get remainingMinutes {
  if (_etaDate == null) return (tiempoMinutos).round();
  final secs = _etaDate!.difference(DateTime.now()).inSeconds;
  return secs <= 0 ? 0 : (secs / 60).ceil();
}


String get distanciaLabel {
  if (distancia >= 1000) return '${(distancia / 1000).toStringAsFixed(1)} km';
  return '${distancia.toStringAsFixed(0)} m';
}


String get etaLabel {
  final eta = _etaDate ?? DateTime.now().add(Duration(minutes: (tiempoMinutos).round()));
  return DateFormat('h:mm a').format(eta).toLowerCase();
}

void stopNavigation() {
  isNavigationActive = false;
  _followUser = false;
  notifyListeners();
}



void _applyNavigationCamera(LatLng pos, {bool centerOnUser = true}) {
  final z = isNavigationActive ? 19.0 : mapController.camera.zoom;

  const double lookAheadM = 40.0;
  final target = centerOnUser
      ? pos
      : _offsetMeters(
          pos,
          lookAheadM * cos(_headingRad),
          lookAheadM * sin(_headingRad),
        );

  final rotationDeg = -(((_headingRad * 180.0 / pi) % 360.0) + 360.0) % 360.0;
  _safeMove(target, z, rotation: rotationDeg);
}



void _checkDeviationAndMaybeReroute(LatLng p) {
  if (!isNavigationActive || !_followUser) return;    
  if (routePoints.length < 2 || selectedPlaceId.isEmpty) return;

  final d = _distancePointToPolylineMeters(p, routePoints);
  final now = DateTime.now();
  final canReroute = _lastRerouteTs == null || now.difference(_lastRerouteTs!) > _rerouteCooldown;

  if (d > deviationThresholdM && canReroute) {
    _lastRerouteTs = now;
    _solicitarRutaDesdeUbicacion(p, selectedPlaceId);
  }
}

double _distancePointToPolylineMeters(LatLng p, List<LatLng> line) {
  if (line.length < 2) return double.infinity;

  double _toMetersX(double lon, double latRef) => lon * 111320.0 * cos(latRef * pi / 180.0);
  double _toMetersY(double lat) => lat * 110540.0;

  final latRef = p.latitude;
  final px = _toMetersX(p.longitude, latRef);
  final py = _toMetersY(p.latitude);

  double best = double.infinity;
  for (int i = 0; i < line.length - 1; i++) {
    final a = line[i];
    final b = line[i + 1];
    final x1 = _toMetersX(a.longitude, latRef);
    final y1 = _toMetersY(a.latitude);
    final x2 = _toMetersX(b.longitude, latRef);
    final y2 = _toMetersY(b.latitude);

    final dx = x2 - x1, dy = y2 - y1;
    final len2 = dx * dx + dy * dy;
    if (len2 == 0) {
      final d = sqrt((px - x1) * (px - x1) + (py - y1) * (py - y1));
      if (d < best) best = d;
      continue;
    }
    double t = ((px - x1) * dx + (py - y1) * dy) / len2;
    t = t.clamp(0.0, 1.0);
    final projX = x1 + t * dx, projY = y1 + t * dy;
    final d = sqrt((px - projX) * (px - projX) + (py - projY) * (py - projY));
    if (d < best) best = d;
  }
  return best;
}

void _emitLocation(LatLng p, {double? accuracy}) {
  final acc = accuracy ?? (lastAccuracyM ?? 20.0);
  _posCtrl.add(LocationMarkerPosition(
    latitude: p.latitude,
    longitude: p.longitude,
    accuracy: acc,
  ));
}

void _emitHeadingRad(double headingRad) {
  final deg = (headingRad * 180.0 / pi) % 360.0;
  _headingCtrl.add(
    LocationMarkerHeading(
      heading: deg,    
      accuracy: 15.0,   
    ),
  );
}

void onUserInteracted() {
  if (_followUser) {
    _followUser = false;
    notifyListeners();
  }
}

 void _setUserMarker(LatLng p, {bool moveCamera = false}) {
  userLocationMarker = Marker(
    point: p,
    width: 40,
    height: 40,
    child: const Icon(Icons.person_pin_circle, size: 40, color: Colors.blue),
  );
  center = p;

  if (moveCamera) {
    final z = mapController.camera.zoom;
final rot = mapController.camera.rotation;
_safeMove(p, z, rotation: rot);   
    try {
      mapController.moveAndRotate(p, z, rot);      
    } catch (_) {
      mapController.move(p, z);                   
    }
  }
  notifyListeners();
}

Future<void> initFusion() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
  }
  if (permission == LocationPermission.deniedForever) return;

  final first = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );
  final firstGps = LatLng(first.latitude, first.longitude);
  lastAccuracyM = first.accuracy;
  _posEstimada = firstGps; 

  _setUserMarker(firstGps, moveCamera: true);
  _emitLocation(firstGps, accuracy: lastAccuracyM);

  _gpsSub?.cancel();
  _gpsSub = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    ),
  ).listen((pos) {
    final gps = LatLng(pos.latitude, pos.longitude);
    final acc = pos.accuracy; 
    lastAccuracyM = acc;

    _applyGpsCorrection(gps, acc);  
    final p = _posEstimada ?? gps;
    _emitLocation(p, accuracy: acc);
    _emitHeadingRad(_headingRad);

if (_followUser && isNavigationActive) {
  _applyNavigationCamera(p); 
} else if (_followUser) {
  
  _safeMove(p, mapController.camera.zoom);
} else {
  _setUserMarker(p, moveCamera: false);
}

if (isNavigationActive) {
  _checkDeviationAndMaybeReroute(p);  
  _recalcRouteThrottled(p);           
}

  });
  _gyroSub?.cancel();
  _gyroSub = gyroscopeEvents.listen((g) {
    final now = DateTime.now();
    final dt = _lastGyroTs == null
        ? 0.0
        : (now.difference(_lastGyroTs!).inMicroseconds / 1e6);
    _lastGyroTs = now;

    _headingRad = _normalizeAngle(_headingRad + g.z * dt);
    _emitHeadingRad(_headingRad); 
    if (isNavigationActive && _followUser && _posEstimada != null) {
  _applyNavigationCamera(_posEstimada!);
}
  });

  _magSub?.cancel();
_magSub = FlutterCompass.events?.listen((event) {  
  final magDeg = event.heading;
  if (magDeg == null) return;
  final magRad = magDeg * pi / 180.0;

  const alpha = 0.96; 
  _headingRad = _normalizeAngle(alpha * _headingRad + (1 - alpha) * magRad);
  _emitHeadingRad(_headingRad);
  if (isNavigationActive && _followUser && _posEstimada != null) {
  _applyNavigationCamera(_posEstimada!);
}
  });

  _accSub?.cancel();
  const double thresh = 1.2; 
  bool above = false;
  _accSub = accelerometerEvents.listen((a) {
    final g = sqrt(a.x * a.x + a.y * a.y + a.z * a.z) / 9.81;
    if (!above && g > thresh) {
      above = true;
      _onStep(); 
    } else if (above && g < 1.0) {
      above = false;
    }
  });
}

double _normalizeAngle(double a) {
  while (a > pi) a -= 2*pi;
  while (a < -pi) a += 2*pi;
  return a;
}

void _onStep() {
  _stepCounter++;
  if (_posEstimada != null) {
  if (isNavigationActive && _followUser) {
    _applyNavigationCamera(_posEstimada!);
  }
  if (isNavigationActive && _followUser && _posEstimada != null) {
  _applyNavigationCamera(_posEstimada!);
}
  if (isNavigationActive) {
    _checkDeviationAndMaybeReroute(_posEstimada!);
  }
 }

  if (_posEstimada != null) {
    final dx = _stepLength * cos(_headingRad);
    final dy = _stepLength * sin(_headingRad);

    _posEstimada = _offsetMeters(_posEstimada!, dx, dy);
    _emitLocation(_posEstimada!, accuracy: 10);
    _emitHeadingRad(_headingRad);

    _setUserMarker(_posEstimada!, moveCamera: _followUser);
    if (isNavigationActive) {
  _recalcRouteThrottled(_posEstimada!);
}
  }
}

LatLng _offsetMeters(LatLng p, double dx, double dy) {
  const R = 6378137.0;
  final dLat = dy / R;
  final dLng = dx / (R * cos(p.latitude * pi / 180.0));
  return LatLng(
    p.latitude + dLat * 180.0 / pi,
    p.longitude + dLng * 180.0 / pi,
  );
}

void _applyGpsCorrection(LatLng gps, double accuracyMeters) {
  _posEstimada ??= gps;
  final w = _weightFromAccuracy(accuracyMeters);
  _posEstimada = LatLng(
    _posEstimada!.latitude  * (1 - w) + gps.latitude  * w,
    _posEstimada!.longitude * (1 - w) + gps.longitude * w,
  );
}

double _weightFromAccuracy(double acc) {
  acc = acc.clamp(5.0, 50.0);
  final t = (acc - 5.0) / (50.0 - 5.0);
  return 0.9 * (1 - t) + 0.2 * t;
}

void _recalcRouteThrottled(LatLng p) {
  if (!_followUser) return;               
  if (selectedPlaceId.isEmpty) return;
  _routeDebounce?.cancel();
  _routeDebounce = Timer(const Duration(seconds: 1), () {
    _solicitarRutaDesdeUbicacion(p, selectedPlaceId);
  });
}

void moveToUserLocation() {
  if (userLocationMarker != null) {
    final z = mapController.camera.zoom;
final rot = mapController.camera.rotation;
_safeMove(userLocationMarker!.point, z, rotation: rot);

    try {
      mapController.moveAndRotate(userLocationMarker!.point, z, rot);
    } catch (_) {
      mapController.move(userLocationMarker!.point, z);
    }
  }
}

void toggleFollowUser() {
  _followUser = !_followUser;
  notifyListeners(); 

  if (_followUser && userLocationMarker != null) {
    mapController.move(userLocationMarker!.point, 17);
  }
}

void toggleNavigation() {
  if (isNavigationActive) {
    stopNavigation();
  } else {
    startNavigation();
  }
  notifyListeners();
}

@override
void dispose() {
  _posSub?.cancel();
  _gpsSub?.cancel();
  _accSub?.cancel();
  _gyroSub?.cancel();
  _magSub?.cancel();
  _routeDebounce?.cancel();
  _posCtrl.close();
  _headingCtrl.close();
  super.dispose();
}

  Future<void> buscarYRutarDesdeBackend(String texto) async {
  try {
    final uri = Uri.parse("$baseUrl/destinos").replace(queryParameters: {"query": texto});
    final r = await http.get(uri);
    if (r.statusCode != 200) return;

    final j = jsonDecode(utf8.decode(r.bodyBytes));
    if (j["items"] == null || (j["items"] as List).isEmpty) return;
    final dest = j["items"][0];

    selectedPlaceId    = dest["id"];
    selectedPlaceName  = dest["nombre"] ?? '';
    selectedPlaceFloor = dest["nivel"]  ?? '';
    selectedPlaceSector= dest["sector"] ?? '';
    selectedPlaceType  = dest["tipo"]   ?? '';

    if (userLocationMarker == null) {
      await _getUserLocation();
      if (userLocationMarker == null) return;
    }

    final pos = userLocationMarker!.point;
    await _solicitarRutaDesdeUbicacion(pos, selectedPlaceId);
    isInfoCardVisible = true;
    notifyListeners();
  } catch (e) {
    logger.e("Error buscarYRutarDesdeBackend: $e");
  }
}

Future<void> mostrar_busqueda(String texto) async {
  final uri = Uri.parse("$baseUrl/destinos").replace(queryParameters: {"query": texto});
  final r = await http.get(uri);
  if (r.statusCode != 200) return;
  final j = jsonDecode(utf8.decode(r.bodyBytes));
  final items = (j["items"] as List?) ?? [];

  markers = items.map((lugar) {
    final lat = (lugar["lat"] as num?)?.toDouble();
    final lng = (lugar["lng"] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return Marker(
      point: LatLng(lat, lng),
      width: 40,
      height: 40,
      child: const Icon(Icons.location_pin, size: 40, color: Colors.green),
    );
  }).whereType<Marker>().toList();

  notifyListeners();
}

Future<void> _solicitarRutaDesdeUbicacion(LatLng origen, String destinoId) async {
  final uri = Uri.parse("$baseUrl/ruta_desde_ubicacion").replace(
    queryParameters: {
      "lat": "${origen.latitude}",
      "lng": "${origen.longitude}",
      "destino": destinoId,
    },
  );

  final r = await http.get(uri);
  if (r.statusCode != 200) {
    routePoints = [];
    notifyListeners();
    return;
  }

  final j = jsonDecode(utf8.decode(r.bodyBytes));
  final ruta = (j["ruta"] as List).map((p) => LatLng(p["lat"], p["lng"])).toList();
  distancia = (j["distancia_total_metros"] ?? j["distancia_m"] ?? 0.0).toDouble();
  distanciaKm = distancia / 1000.0;
  final double velocidadKmH = 5.0; 
  tiempoHoras   = distanciaKm / velocidadKmH;
  tiempoMinutos = tiempoHoras * 60.0;
  _etaDate = DateTime.now().add(Duration(minutes: tiempoMinutos.round()));
  routePoints = ruta;
  markers = [];
  if (routePoints.isNotEmpty) {
    final destinoPoint = routePoints.last;
    markers.add(
      Marker(
        point: destinoPoint,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
      ),
    );
  }

  notifyListeners();
 }
  void hideInfoCard(){
    isCollapse = true;
    notifyListeners();
  }
  void showInfoCard() {
    isCollapse = false;
    notifyListeners();
  }
  
}
