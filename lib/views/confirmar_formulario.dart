import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '/models/form_data.dart'; 



class ConfirmarFormScreen extends StatefulWidget {
  final String base64LogoHeader;
  final String base64LogoFooter;
  final FormData formData;

  const ConfirmarFormScreen(this.formData,{
    super.key,
    required this.base64LogoHeader,
    required this.base64LogoFooter,
  });

  @override
  State<ConfirmarFormScreen> createState() => _ConfirmarFormScreenState();
}

class _ConfirmarFormScreenState extends State<ConfirmarFormScreen> {
  late InAppWebViewController webViewController;

  // Función para generar PDF desde HTML usando el paquete printing
  Future<void> generarPdfDesdeHtml(htmlData) async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return await Printing.convertHtml(
            format: format,
            html: htmlData, // aquí está la clave
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String htmlData = '''
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8" />
<title>Carta-Solicitud C.A.E.  FAHU</title>
<meta name="viewport" content="width=device-width,initial-scale=1" />

<!-- ==========  ESTILOS  ========== -->
<style>
:root{
  --verde:#009b9b;
  --gris:#2f2f2f;
  --borde:#000;
  --dark:#222d34;            /* franja inferior */
  --font:"Helvetica","Arial",sans-serif;
}
*{box-sizing:border-box;font-family:var(--font)}
html,body{margin:0;background:#fff;color:var(--gris)}

/* ----------  CONTENEDOR 80 % ---------- */
.page{width:100%;max-width: 816px;;margin:0 auto}

/* ----------  ENCABEZADO ---------- */
header{
  border-top:18px solid var(--verde);
  padding:1.4rem 0 1rem;
  display:flex;align-items:center;gap:1.2rem;
}
.footer-inner {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  flex-wrap: wrap;
  margin-top: 1rem;
}
.contenido {
  width: 80%;
  margin: 0 auto;
}
.footer-text {
  max-width: 60%;
  font-size: .78rem;
  line-height: 1.2;
}

header img{height:65px}

/* ----------  TÍTULOS ---------- */
h1{font-weight:900;font-size:1.28rem;text-align:center;margin:.45rem 0 0}
h2{font-weight:700;font-size:.92rem;text-align:center;margin:0 0 1.25rem}

/* ----------  FORMULARIO ---------- */
form{padding:0 1rem}
input[type="text"],
input[type="date"],
input[type="email"] {
  border: none;
  width: 60%;
  border-bottom: 1px solid #000;
  font-size: 0.95rem;
  background: transparent;
  padding: 0.2rem 0;
  outline: none;
}

.underlined-text {
  display: inline-block;
  border-bottom: 1px solid #000;
  min-width: 60%;  /* o el ancho que necesites */
  padding-bottom: 2px; /* espacio entre texto y línea */
}

label.inline-label {
  display: inline-block;
  margin-right: 0.6rem;
}
.inline-group {
  display: flex;
  gap: 1.5rem;
  align-items: center;
  margin-bottom: 1rem;
}
textarea{
  width:100%;min-height:180px;border:1px solid var(--borde);
  padding:.45rem .55rem;resize:vertical
}

/* tabla de opciones */
table{width:100%;border-collapse:collapse;margin:.85rem 0 1rem}
td{border:1px solid var(--borde);padding:.38rem .5rem;font-size:.86rem}
input[type=checkbox]{
  appearance:none;width:16px;height:16px;border:2px solid var(--borde);
  border-radius:2px;vertical-align:middle;margin-right:.42rem;cursor:pointer;position:relative
}
input[type=checkbox]:checked{background:var(--verde);border-color:var(--verde)}
input[type=checkbox]:checked::after{
  content:"";position:absolute;left:3px;top:-1px;width:4px;height:9px;
  border:solid #fff;border-width:0 2px 2px 0;transform:rotate(45deg)
}

/* firma */
.firma-zone{margin-top:2.1rem}
.firma-preview{
  border:1px dashed var(--borde);height:110px;
  display:flex;align-items:center;justify-content:center;
  font-size:.78rem;color:#999;margin-bottom:.55rem;text-align:center
}
.firma-preview img{max-height:100%;max-width:100%}

/* adjuntos */
.adjunta{margin-top:1.35rem;font-size:.96rem}
.adj-inputs{margin-top:.5rem;display:none}

/* botón */
button{
  margin:2.2rem 0 3.1rem;padding:.72rem 2.3rem;border:none;border-radius:4px;
  background:var(--verde);color:#fff;font-weight:700;font-size:1rem;cursor:pointer;text-transform:uppercase
}
button:hover{opacity:.92}

/* ----------  FOOTER (dentro del 80 %) ---------- */
footer.page{font-size:.78rem;color:#666;margin-top:2.5rem}

.footer-text{line-height:1.2;max-width:55%}
.footer-text a{color:inherit;text-decoration:none}
.skyline{
  width:40%;max-width:260px;height:auto;margin-right:1rem
}
.sep{height:2px;background:var(--verde);margin:0}
.brand {
  background: var(--dark);
  color: #1db2ab;
  font-weight: 700;
  padding: .5rem 1.5rem;
  font-size: .9rem;
  text-align: left; /* <- AQUÍ está la clave */
}
</style>
</head>

<body>

<div class="page">

  <!-- ==========  ENCABEZADO  ========== -->
  <header>
    <!-- Usa tu ruta real al logo -->
    <img src="data:image/png;base64,${widget.base64LogoHeader}" alt="Logo Facultad de Humanidades USACH" />
  </header>

  <h1>CARTA&nbsp;-&nbsp;SOLICITUD</h1>
  <h2>CONCESIÓN ACADÉMICA EXCEPCIÓN (C.A.E.)</h2>
  
  <div class="contenido">
  <!-- ==========  FORMULARIO  ========== -->
  <form id="form-cae">
    <label>Fecha: </label><span class="underlined-text" style="width: 90%;">${widget.formData.fecha}</span>
   <br><br>
    <label>Nombre completo: </label><span class="underlined-text" style="width: 77%;">${widget.formData.nombre}</span>
    <br><br>
    <div class="inline-group">
      <label class="inline-label">C.I.: </label>
      <span class="underlined-text" style="width: 30%;">${widget.formData.ci}</span>

      <label class="inline-label">FONO: </label>
      <span class="underlined-text" style="width: 30%;">+56 ${widget.formData.fono}</span>
    </div>

    <label>Carrera: </label><span class="underlined-text" style="width: 89%;">${widget.formData.carrera}</span>
    <br><br>
    <label>Correo: </label><span class="underlined-text" style="width: 90%;">${widget.formData.correo}</span>
    <br><br>

    <p style="margin:.9rem 0 .35rem"><strong>A:&nbsp;&nbsp;     VICE-DECANO DE DOCENCIA&nbsp;FAHU</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sr. Saúl Contreras Palma</p>

    <p style="margin:.35rem 0 .35rem">Solicito su autorización para:</p>

    <table>
      <tr>
        <td><label><input type="checkbox" name="opciones" value="3ra_opcion_1req">Cursar asignatura en 3ra. opción −1&nbsp;req.</label></td>
        <td><label><input type="checkbox" name="opciones" value="reinc_titulacion">Reincorporación titulación fuera de plazo</label></td>
      </tr>
      <tr>
        <td><label><input type="checkbox" name="opciones" value="3ra_opcion_sr">Cursar asignatura en 3ra. opción&nbsp;S/R</label></td>
        <td><label><input type="checkbox" name="opciones" value="prorroga">Prórroga fuera de plazo</label></td>
      </tr>
      <tr>
        <td><label><input type="checkbox" name="opciones" value="tutoria_r">Cursar asignatura por tutoría (asig.&nbsp;R)</label></td>
        <td><label><input type="checkbox" name="opciones" value="retiro_temporal">Retiro Temporal fuera de plazo</label></td>
      </tr>
      <tr>
        <td><label><input type="checkbox" name="opciones" value="sin_req">Cursar asignatura c/s req.&nbsp;(R)</label></td>
        <td><label><input type="checkbox" name="opciones" value="ampliacion">Ampliación fuera de plazo</label></td>
      </tr>
      <tr>
        <td><label><input type="checkbox" name="opciones" value="reincorporacion">Reincorporación fuera de plazo</label></td>
        <td><label><input type="checkbox" name="opciones" value="otros">Otros</label></td>
      </tr>
    </table>

    <label>Fundamentación</label>
    <textarea name="fundamentacion" required></textarea>

    <!-- firma -->
    <div class="firma-zone">
      <label>Firma (PNG)</label>
      <div class="firma-preview" id="firmaPreview">Previsualización firma</div>
    </div>

    <!-- adjuntos -->
    <div class="adjunta">
      Adjunta antecedentes:
      <label style="margin-left:.55rem"><input type="radio" name="antecedentes_si" value="si" required> Sí</label>
      <label style="margin-left:1.15rem"><input type="radio" name="antecedentes_si" value="no" required> No</label>

      <div class="adj-inputs" id="adjInputs">
        <input type="file" name="adjuntos" accept=".doc,.docx,.pdf,.png" multiple>
        <small>(.doc, .docx, .pdf, .png)</small>
      </div>
    </div>
  </form>
  </div>

  <!-- ==========  FOOTER  ========== -->
  <footer>
    <div class="footer-inner">
      <div class="footer-text">
        <p>UNIVERSIDAD DE SANTIAGO DE CHILE</p>
        <p>Av. Libertador Bernardo OHiggins n°3363 Estación Central  Santiago  Chile</p>
        <p><a href="https://www.usach.cl">www.usach.cl</a></p>
      </div>
      <!-- Usa tu imagen real del skyline -->
      <img src="data:image/png;base64,${widget.base64LogoFooter}" class="skyline" alt="Logo pie de página" />
    </div>
    <div class="sep"></div>
    <div class="brand">
  <span style="color:#f47c20">#</span><span style="color:#ffffff">SOMOS</span><span style="color:#55c1b0">USACH</span>
</div>

  </footer>

</div><!-- /page -->



</body>
</html>
''';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vista previa PDF"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => generarPdfDesdeHtml(htmlData),
            tooltip: 'Generar PDF',
          ),
        ],
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: htmlData,
          baseUrl: WebUri("https://localhost"), // para rutas relativas
          encoding: "utf-8",
          mimeType: "text/html",
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}
