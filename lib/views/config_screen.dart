import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:humanidades360/l10n/app_localizations.dart';
import '../controllers/settings_controller.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settings = Provider.of<SettingsController>(context);

    // Función para mostrar selección de idioma
    void _showLanguageSelection() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations.cs_language,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ...['es', 'en'].map((language) {
                  return ListTile(
                    title: Text(language == 'es' ? 'Español' : 'English'),
                    trailing: settings.locale.languageCode == language
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      settings.setLocale(Locale(language));
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.cs_settingsTitle),
      ),
      body: ListView(
        children: [
          // Idioma con modal bottom sheet
          ListTile(
            leading: const Icon(Icons.language, color: Colors.black),
            title: Text(localizations.cs_language),
            subtitle: Text(settings.locale.languageCode == 'es' 
                ? 'Español' : 'English'),
            onTap: _showLanguageSelection,
          ),
          
          // Tema
          ListTile(
            leading: const Icon(Icons.color_lens, color: Colors.black),
            title: Text(localizations.cs_theme),
            subtitle: Text(settings.theme == 'light' 
                ? 'Light' : 'Dark'),
            onTap: () {
              settings.setTheme(settings.theme == 'light' ? 'dark' : 'light');
            },
          ),
          
          // Notificaciones
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.black),
            title: Text(localizations.cs_notifications),
            trailing: Switch(
              value: false,
              onChanged: (value) {
              },
            ),
          ),
          
          // Rutas guardadas
          ListTile(
            leading: const Icon(Icons.save, color: Colors.black),
            title: Text(localizations.cs_savedRoutes),
            onTap: () {
              // Navegar a rutas guardadas
            },
          ),
          
          // Unidades
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline_sharp, color: Colors.black),
            title: Text(localizations.cs_units),
            subtitle: Text(settings.unit == 'metros' 
                ? 'Metros' : 'Millas'),
            onTap: () {
              settings.setUnit(settings.unit == 'metros' ? 'millas' : 'metros');
            },
          ),
          
          // Ayuda y soporte
          ListTile(
            leading: const Icon(Icons.help, color: Colors.black),
            title: Text(localizations.cs_helpAndSupport),
            onTap: () {
              // Navegar a ayuda y soporte
            },
          ),
          
          // Cerrar sesión
          /* Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Lógica para cerrar sesión
              },
              child: Text(
                '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ), */
        ],
      ),
    );
  }
}