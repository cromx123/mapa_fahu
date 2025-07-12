// views/config_screen.dart
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

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: Colors.black),
            title: Text(localizations.language),
            trailing: DropdownButton<String>(
              value: settings.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                 settings.setLocale(Locale(value));
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens, color: Colors.black),
            title: Text(localizations.theme),
            trailing: DropdownButton<String>(
              value: settings.theme,
              items: const [
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
              onChanged: (value) {
                if (value != null) {
                 settings.setTheme(value);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.black),
            title: Text(localizations.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.save, color: Colors.black),
            title: Text(localizations.savedRoutes),
          ),
          ListTile(
            leading: const Icon(Icons.drive_file_rename_outline_sharp, color: Colors.black),
            title: Text(localizations.units),
            trailing: DropdownButton<String>(
              value: settings.unit,
              items: const [
                DropdownMenuItem(value: 'metros', child: Text('Metros')),
                DropdownMenuItem(value: 'millas', child: Text('Millas')),
              ],
              onChanged: (value) {
                if (value != null) {
                 settings.setUnit(value);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.black),
            title: Text(localizations.helpAndSupport),
          ),
        ],
      ),
    );
  }
}

