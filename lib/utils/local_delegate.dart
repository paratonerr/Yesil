import 'package:flutter/cupertino.dart';
import 'package:solution_challenge/utils/app_localizations.dart';

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations>{
  @override
  bool isSupported(Locale locale) {
    // TODO: implement isSupported
  return ['en','tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale)async {
    AppLocalizations   appLocalization =   AppLocalizations(locale);
    appLocalization.loadStrings();
    return appLocalization;
     

  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    // TODO: implement shouldReload
    return false;
  }
}