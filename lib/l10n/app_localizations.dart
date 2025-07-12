import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Campus Map'**
  String get title;

  /// No description provided for @cs_settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get cs_settingsTitle;

  /// No description provided for @cs_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get cs_language;

  /// No description provided for @cs_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get cs_theme;

  /// No description provided for @cs_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get cs_notifications;

  /// No description provided for @cs_savedRoutes.
  ///
  /// In en, this message translates to:
  /// **'Saved Routes'**
  String get cs_savedRoutes;

  /// No description provided for @cs_units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get cs_units;

  /// No description provided for @cs_helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get cs_helpAndSupport;

  /// No description provided for @ms_menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get ms_menuTitle;

  /// No description provided for @ms_login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get ms_login;

  /// No description provided for @ms_portalUsach.
  ///
  /// In en, this message translates to:
  /// **'USACH Portal'**
  String get ms_portalUsach;

  /// No description provided for @ms_portalFahu.
  ///
  /// In en, this message translates to:
  /// **'FaHu Portal'**
  String get ms_portalFahu;

  /// No description provided for @ms_portalAlumnos.
  ///
  /// In en, this message translates to:
  /// **'Student Portal'**
  String get ms_portalAlumnos;

  /// No description provided for @ms_onlineServices.
  ///
  /// In en, this message translates to:
  /// **'Online Services'**
  String get ms_onlineServices;

  /// No description provided for @ms_onlineLibrary.
  ///
  /// In en, this message translates to:
  /// **'Online Library'**
  String get ms_onlineLibrary;

  /// No description provided for @ms_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get ms_settings;

  /// No description provided for @ms_helpInfo.
  ///
  /// In en, this message translates to:
  /// **'Help and Information'**
  String get ms_helpInfo;

  /// No description provided for @cms_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search place...'**
  String get cms_searchHint;

  /// No description provided for @cms_voiceSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Voice search'**
  String get cms_voiceSearchTooltip;

  /// No description provided for @cms_openMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get cms_openMenuTooltip;

  /// No description provided for @cms_filterLibraries.
  ///
  /// In en, this message translates to:
  /// **'Libraries'**
  String get cms_filterLibraries;

  /// No description provided for @cms_filterCasinos.
  ///
  /// In en, this message translates to:
  /// **'Cafeterias'**
  String get cms_filterCasinos;

  /// No description provided for @cms_filterBathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get cms_filterBathrooms;

  /// No description provided for @cms_filterOthers.
  ///
  /// In en, this message translates to:
  /// **'others...'**
  String get cms_filterOthers;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
