// views/formulario_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlWidget extends StatelessWidget {
  final String htmlData = """
    <h2>Título en HTML</h2>
    <p>Este es un párrafo <b>en negrita</b> con <a href='https://flutter.dev'>un enlace</a>.</p>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Renderizar HTML')),
      body: SingleChildScrollView(
        child: Html(data: htmlData),
      ),
    );
  }
}
