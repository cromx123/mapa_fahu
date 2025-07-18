// form_data.dart
class FormData {
  final String fecha;
  final String nombre;
  final String ci;
  final String fono;
  final String carrera;
  final String correo;
  final List<String> opciones;
  final String fundamentacion;
  final List<String> adjfiles; 

  FormData({
    required this.fecha,
    required this.nombre,
    required this.ci,
    required this.fono,
    required this.carrera,
    required this.correo,
    required this.opciones,
    required this.fundamentacion,
    required this.adjfiles,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
      fecha: json['fecha'],
      nombre: json['nombre'],
      ci: json['ci'],
      fono: json['fono'],
      carrera: json['carrera'],
      correo: json['correo'],
      opciones: List<String>.from(json['opciones'] ?? []),
      fundamentacion: json['fundamentacion'],
      adjfiles: List<String>.from(json['adj_files'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'fecha': fecha,
        'nombre': nombre,
        'ci': ci,
        'fono': fono,
        'carrera': carrera,
        'correo': correo,
        'opciones': opciones,
        'fundamentacion': fundamentacion,
        'adj_files': adjfiles,
      };
}
