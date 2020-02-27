import 'depricated_language_tags.dart';

const String defaultLanguage = 'defLang';

/// LanguageWithParent aggregates a language and
/// its logical parent language.
///
/// It is used when we generate the language classes.
class LanguageWithParent {
  final LocaleInfo _parent;
  final LocaleInfo _language;

  String get parent => _parent.language;
  String get language => _language.language;

  bool get isDefaultLanguage => _language.isDefaultLanguage;

  String get prefix => _language.prefix;
  String get prefixParent => _parent.prefix;

  String get extendsClass =>
    _parent.isUndefined ? '' : 'extends ${_parent.prefix}';


  LanguageWithParent({String language, String parent}):
      this._parent = LocaleInfo(parent),
      this._language = LocaleInfo(language);

  @override String toString() {
    return '($language, $parent)';
  }
}

/// For each given language,
/// LanguageHierarchy establishes a logical parent child relation.
class LanguageHierarchy {
  Set<LanguageWithParent> _entries;
  final LanguageWithParent _defaultLanguage;

  LanguageHierarchy() :
      _entries = Set() ,
      _defaultLanguage = LanguageWithParent(language: defaultLanguage, parent: null) {
    _entries.add(_defaultLanguage);
  }

  LanguageWithParent get defLanguage => _defaultLanguage;

  List<LanguageWithParent> get languages {
    var res = _entries.toList();
    res.sort((a, b) => a.language.compareTo(b.language));
    return res;
  }

  void add(String language) {
    LocaleInfo localeInfo = LocaleInfo(language);
    _establish(localeInfo.languageCode, defaultLanguage);
    if (localeInfo.hasCountryCode) {
      String lngCountry = '${localeInfo.languageCode}_${localeInfo.countryCode}';
      _establish(lngCountry, localeInfo.languageCode);
      if (localeInfo.hasVariant) {
        String lngCountryVar = '${lngCountry}_${localeInfo.variant}';
        _establish(lngCountryVar, lngCountry);
      }
    }
  }

  void merge(LanguageHierarchy other) {
    for (var entry in other._entries) {
      _establish(entry.language, entry.parent);
    }
  }

  void _establish(String language, String parent) {
    _entries.firstWhere((element) => element.language == language,
      orElse: () {
        _entries.add(LanguageWithParent(language: language, parent: parent));
        return null;
      }
    );
  }
}

class LocaleInfo {
  static final String undefinedLanguageCode = 'und';

  String get languageCode => _languageCode;
  String get countryCode => _countryCode;
  String get variant => _variant;

  bool get hasVariant => _variant != null;
  bool get hasCountryCode => _countryCode != null;
  bool get isUndefined => languageCode == undefinedLanguageCode;
  bool get isDefaultLanguage => languageCode == defaultLanguage;

  String get language {
    StringBuffer tag = StringBuffer(languageCode);
    if (hasCountryCode) tag.write('_$countryCode');
    if (hasVariant) tag.write('_$variant');
    return tag.toString();
  }

  String get prefix =>  isUndefined ? '' : '\$${language}_';

  String _languageCode;
  String _countryCode;
  String _variant;

  LocaleInfo(String tag, {String delimiter = '_'}) {
    if (tag == null || tag.isEmpty) {
      _languageCode = undefinedLanguageCode;
      return;
    }

    List<String> split = tag.split(delimiter);
    String lng = languageCodeTranslated(split[0]); // Locale(split[0]).languageCode;
    _languageCode = lng ?? split[0];
    if (split.length > 1) {_countryCode = split[1]; }
    if (split.length > 2) {_variant = split[2]; }
  }

  bool operator ==(other) => language == other.language;
  int get hashCode => language.hashCode;

  @override String toString() {
    return '($languageCode, $countryCode, $variant)';
  }
}
