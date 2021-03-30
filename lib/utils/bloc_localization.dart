import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge/utils/app_localizations.dart';
import 'package:solution_challenge/utils/prefLanguage.dart';

enum LocaleEvent { EN, TR }

class BlocLocalization extends Bloc<LocaleEvent, Locale> {
  @override
  Locale get initialState => Locale("en");

  @override
  Stream<Locale> mapEventToState(LocaleEvent event) async* {
    Locale locale = event == LocaleEvent.TR ? Locale("tr") : Locale("en");
    await AppLocalizations.updateLocale(locale);
    PrefUtils.saveLanguage(locale);
    yield locale;
  }
}