// views/formulario_screen.dart
import 'package:flutter/material.dart';


class HtmlWidget extends StatelessWidget {
  static const String htmlData = """
    <h2>Título en HTML</h2>
    <p>Este es un párrafo <b>en negrita</b> con <a href='https://flutter.dev'>un enlace</a>.</p>
  """;

  const HtmlWidget({super.key});

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
