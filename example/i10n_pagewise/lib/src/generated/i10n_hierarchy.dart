import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unnecessary_brace_in_string_interps

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
class S implements WidgetsLocalizations {
  static S current;
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();
  static S of(BuildContext context) => Localizations.of<S>(context, S);
  static S forLanguage(String language) => _langMap.containsKey(language) ? _langMap[language]() : $defLang_();
  static Set<String> get languages => _langMap.keys.toSet();
  static Map<String, Function>_langMap = {
    'de': () => $de_(),
    'de_CH': () => $de_CH_(),
    'en': () => $en_(),
  };

  @override TextDirection get textDirection => TextDirection.ltr;

  /// This is a comment for the key 'appTitle'
  /// This is an other comment for the key 'appTitle'
  /// {it_doesNot_matter: what's in a ${comment value}}
  String get appTitle => 'I10n Demo';
  final $defLang_StartPage startPage = $defLang_StartPage();
  final $defLang_OverviewPage overviewPage = $defLang_OverviewPage();
  final $defLang_DirectTranslPage directTranslPage = $defLang_DirectTranslPage();
}

class $defLang_ extends S {}

class $defLang_StartPage {
  String get title => 'Start Page';
  String get btnOverview => 'Show translation types';
  String get btnSpecialTranslation => 'Single widget translation';
}

class $defLang_OverviewPage {
  String get title => 'Translation Types';
  String get tooltip => 'Click to increment the counter';
  final $defLang_OverviewPageSimpleTr simpleTr = $defLang_OverviewPageSimpleTr();
  final $defLang_OverviewPageParametrizedTr parametrizedTr = $defLang_OverviewPageParametrizedTr();
  final $defLang_OverviewPagePluralTr pluralTr = $defLang_OverviewPagePluralTr();
  final $defLang_OverviewPagePluralParamTr pluralParamTr = $defLang_OverviewPagePluralParamTr();
  final $defLang_OverviewPageGenderTr genderTr = $defLang_OverviewPageGenderTr();
}

class $defLang_OverviewPageSimpleTr {
  String get dsc => 'A simple translation';
  String get tr => 'Click the increment button!';
}

class $defLang_OverviewPageParametrizedTr {
  String get dsc => 'A parametrized translation';
  String tr({@required dynamic count}) => 'You earned ${count} \$';
}

class $defLang_OverviewPagePluralTr {
  String get dsc => 'A plural translation';
  /// - selector in [0, 1, 2, other]
  String tr(dynamic selector, ) {
    switch (selector.toString()) {
      case '0': return 'Are you afraid to click the button?';
      case '1': return 'You clicked once';
      case '2': return 'You clicked twice';
      default: return 'Clicking is fun, isn\'t it?';
    }
  }
}

class $defLang_OverviewPagePluralParamTr {
  String get dsc => 'A plural translation with parameter';
  /// - selector in [0, 1, 2, other], parameters : {count}
  String tr(dynamic selector, {dynamic count}) {
    switch (selector.toString()) {
      case '0': return 'You haven\'t clicked the button yet';
      case '1': return 'You clicked it once';
      case '2': return 'You clicked it twice';
      default: return 'You clicked it ${count} times';
    }
  }
}

class $defLang_OverviewPageGenderTr {
  String get dsc => 'A gender translation';
  /// - selector in [male, female, other]
  String tr(dynamic selector, ) {
    switch (selector.toString()) {
      case 'male': return 'I am a male';
      case 'female': return 'I am a female';
      default: return 'I am still searching my way...';
    }
  }
}


class $defLang_DirectTranslPage {
  String get title => 'Translate the quote';
  String get descr => 'Translate a single widget to another language';
  String get de => 'German';
  String get de_CH => 'Swiss German';
  String get en => 'English';
  String get quote => 'This is not a love song';
}

class $de_ extends $defLang_ {
  @override String get appTitle => 'I10n Beispiel';
  final $defLang_StartPage startPage = $de_StartPage();
  final $defLang_OverviewPage overviewPage = $de_OverviewPage();
  final $defLang_DirectTranslPage directTranslPage = $de_DirectTranslPage();
}

class $de_StartPage extends $defLang_StartPage {
  @override String get title => 'Startseite';
  @override String get btnOverview => 'Zeige Übersetzungsarten';
  @override String get btnSpecialTranslation => 'Zeige Widget-Übersetzung';
}

class $de_OverviewPage extends $defLang_OverviewPage {
  @override String get title => 'Übersetzungsarten';
  @override String get tooltip => 'Klicken um den Zähler zu erhöhen';
  final $defLang_OverviewPageSimpleTr simpleTr = $de_OverviewPageSimpleTr();
  final $defLang_OverviewPageParametrizedTr parametrizedTr = $de_OverviewPageParametrizedTr();
  final $defLang_OverviewPagePluralTr pluralTr = $de_OverviewPagePluralTr();
  final $defLang_OverviewPagePluralParamTr pluralParamTr = $de_OverviewPagePluralParamTr();
  final $defLang_OverviewPageGenderTr genderTr = $de_OverviewPageGenderTr();
}

class $de_OverviewPageSimpleTr extends $defLang_OverviewPageSimpleTr {
  @override String get dsc => 'Eine einfache Übersetzung';
  @override String get tr => 'Klicken Sie auf den Zählerknopf!';
}

class $de_OverviewPageParametrizedTr extends $defLang_OverviewPageParametrizedTr {
  @override String get dsc => 'Eine Übersetzung mit Parameter';
  @override String tr({@required dynamic count}) => 'Sie haben ${count} mal geklickt';
}

class $de_OverviewPagePluralTr extends $defLang_OverviewPagePluralTr {
  @override String get dsc => 'Eine Mehrzahlübersetzung';
  /// - selector in [0, 1, 2, other]
  @override String tr(dynamic selector, ) {
    switch (selector.toString()) {
      case '0': return 'Haben Sie Angst den Zählerknopf zu drücken?';
      case '1': return 'Sie haben einmal geklickt';
      case '2': return 'Sie haben zweimal geklickt';
      default: return 'Klicken macht Spass, oder?';
    }
  }
}

class $de_OverviewPagePluralParamTr extends $defLang_OverviewPagePluralParamTr {
  @override String get dsc => 'Eine Mehrzahlübersetzung mit Zusatzparameter';
  /// - selector in [0, 1, 2, other], parameters : {count}
  @override String tr(dynamic selector, {dynamic count}) {
    switch (selector.toString()) {
      case '0': return 'Sie haben den Knopf nie gedrückt';
      case '1': return 'Sie haben ihn einmal gedrückt';
      case '2': return 'Sie haben ihn zweimal gedrückt';
      default: return 'Sie haben ihn ${count} mal gedrückt';
    }
  }
}

class $de_OverviewPageGenderTr extends $defLang_OverviewPageGenderTr {
  @override String get dsc => 'Eine geschlechtsabhängige Übersetzung';
  /// - selector in [male, female, other]
  @override String tr(dynamic selector, ) {
    switch (selector.toString()) {
      case 'male': return 'Ich bin männlich';
      case 'female': return 'Ich bin weiblich';
      default: return 'Kann mich gar nicht Entscheiden...';
    }
  }
}


class $de_DirectTranslPage extends $defLang_DirectTranslPage {
  @override String get title => 'Zitatübersetzer';
  @override String get descr => 'Überstzen in eine beliebige Sprache';
  @override String get de => 'Deutsch';
  @override String get de_CH => 'Schweizerdeutsch';
  @override String get en => 'Englisch';
  @override String get quote => 'Dies ist kein Liebeslied';
}

class $de_CH_ extends $de_ {
  final $defLang_DirectTranslPage directTranslPage = $de_CH_DirectTranslPage();
}

class $de_CH_DirectTranslPage extends $de_DirectTranslPage {
  @override String get quote => 'Das isch keis Liebeslied';
}

class $en_ extends $defLang_ {
}


class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return <Locale>[
      Locale("de", ""),
      Locale("de", "CH"),
      Locale("en", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return _getFallback(fallback, supported.first);
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
      case "de":
        S.current = $de_();
        return SynchronousFuture<S>(S.current);
      case "de_CH":
        S.current = $de_CH_();
        return SynchronousFuture<S>(S.current);
      case "en":
        S.current = $en_();
        return SynchronousFuture<S>(S.current);
        default:
          // NO-OP.
      }
    }
    S.current = S();
    return SynchronousFuture<S>(S.current);
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported, bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return _getFallback(fallback, supported.first);
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = _getFallback(fallback, supported.first);
      return fallbackLocale;
    }
  }

  Locale _getFallback(Locale fallback, Locale firstInList) {
    return fallback ?? (defaultLocale ?? firstInList);
  }
  
  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry && (supportedLocale.countryCode == null || supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();

const Locale defaultLocale = Locale("en", "");
