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
                    title: Text(language == 'es' ? localizations.cs_languageSpanish : localizations.cs_languageEnglish),
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
    void _showThemeSelection() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations.cs_theme,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ...[
                  {'label': localizations.cs_themeLight , 'mode': ThemeMode.light},
                  {'label': localizations.cs_themeDark , 'mode': ThemeMode.dark},
                  {'label': localizations.cs_themeSystem, 'mode': ThemeMode.system},
                ].map((item) {
                  return ListTile(
                    title: Text(item['label'] as String),
                    trailing: settings.themeMode == item['mode']
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      settings.setThemeMode(item['mode'] as ThemeMode);
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
            leading: Icon(Icons.language, color: Theme.of(context).iconTheme.color),
            title: Text(localizations.cs_language),
            subtitle: Text(settings.locale.languageCode == 'es' ? localizations.cs_languageSpanish : localizations.cs_languageEnglish),
            onTap: _showLanguageSelection,
          ),
          
          ListTile(
            leading: Icon(Icons.color_lens, color: Theme.of(context).iconTheme.color),
            title: Text(localizations.cs_theme), 
            subtitle: Text(
              settings.themeMode == ThemeMode.light
                ? localizations.cs_themeLight 
                : settings.themeMode == ThemeMode.dark
                    ? localizations.cs_themeDark 
                    : localizations.cs_themeSystem, 
            ),
            onTap: _showThemeSelection,
          ),
          
          // Notificaciones
          ListTile(
            leading: Icon(Icons.notifications, color: Theme.of(context).iconTheme.color),
            title: Text(localizations.cs_notifications),
            trailing: Switch(
              value: false,
              onChanged: (value) {
              },
            ),
          ),
          
          // Eventos
          ListTile(
            leading: Icon(Icons.event, color: Theme.of(context).iconTheme.color),
            title: Text(localizations.cs_events),
            subtitle: Text(
              localizations.cs_eventsSubtitle,
              semanticsLabel: localizations.cs_eventsSubtitle + ' toggle',
            ),
            trailing: Switch(
              value: false,
              onChanged: (value) {
              },
            ),
          ),

          // Rutas guardadas
          ListTile(
            leading: Icon(Icons.save, color: Theme.of(context).iconTheme.color),
            title: Text(localizations.cs_savedRoutes),
            onTap: () {
              // Navegar a rutas guardadas
            },
          ),
          
          // Unidades
          ListTile(
            leading: Icon(Icons.drive_file_rename_outline_sharp, color: Theme.of(context).iconTheme.color),
            title: Text(localizations.cs_units),
            subtitle: Text(settings.unit == 'metros' ? 'Metros' : 'Millas'),
            onTap: () {
              settings.setUnit(settings.unit == 'metros' ? 'millas' : 'metros');
            },
          ),
          
          // Ayuda y soporte
          ListTile(
            leading: Icon(Icons.help, color: Theme.of(context).iconTheme.color),
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