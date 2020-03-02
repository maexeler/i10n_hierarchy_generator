import 'package:i10n_hierarchy_generator/src/language/language_helper.dart';

/// Each [Translation] is valid for a given language
/// and contains a key-value pair.
///
/// Its subclasses are responsible for code generation
abstract class Translation<V> {
  Translation(String language, String key, V payload)
      : _language = language ?? defaultLanguage,
        _key = normalizeKey(key),
        _payload = payload;

  String get key => _key;
  V get payload => _payload;
  String get language => _language;

  String asCode(bool override);

  // private implementation

  String _key;
  final V _payload;
  final String _language;

  static String normalizeKey(String key) =>
      key[0].toLowerCase() + key.substring(1);
}

class CommentTranslation extends Translation<dynamic> {
  CommentTranslation(String language, String key, dynamic payload)
      : super(language, key, payload);

  @override
  String asCode(bool override) {
    return '  /// $_payload';
  }
}

class SimpleTranslation extends Translation<String> {
  SimpleTranslation(String language, String key, String payload)
      : super(language, key, payload);

  @override
  String asCode(bool override) {
    String ov = override ? '@override ' : '';
    return _payload != null
        ? "  ${ov}String get $key => '${_escapeOutput(_payload)}';"
        : '';
  }
}

class ParametrizedTranslation extends Translation<String> {
  ParametrizedTranslation(String language, String key, String payload)
      : super(language, key, payload);

  @override
  String asCode(bool override) {
    String ov = override ? '@override ' : '';
    List<String> params = _extractAllParameter(_payload);
    assert(params.isNotEmpty);

    final StringBuffer res = StringBuffer();
    res.write(
        "  ${ov}String $key({@required dynamic ${params.join(', @required dynamic ')}}) => '${_escapeOutput(_payload)}';");
    return res.toString();
  }

  static bool isParametrizedNode(String value) {
    return _parameterRegExp.hasMatch(value);
  }
}

class PluralTranslation extends Translation<List<PluralValue>> {
  static const String selector = 'selector';

  PluralTranslation(String language, String key, String value)
      : super(language, key, []) {
    PluralValue pluralValue = PluralValue(key, value);
    this._key = pluralValue.key;
    this._payload.add(pluralValue);
  }

  bool addPlural(PluralTranslation other) {
    if (key != other.key || language != other.language) return false;

    assert(other.payload.isNotEmpty);
    payload.add(other.payload[0]);
    return true;
  }

  @override
  String asCode(bool override) {
    if (_hasNoOtherPlural()) {
      print('Warning: Found a plural-Item without an Other-Item.'
          ' No code is generated for the key: $key');
      return '';
    }

    // Generate the code
    final codeBuffer = StringBuffer();
    String ov = override ? '@override ' : '';
    codeBuffer.writeln(_generateComments('  '));
    codeBuffer.writeln(
        '  ${ov}String $key(dynamic $selector, ${_generateExtraPrams()}) {');
    codeBuffer.writeln('    switch (${selector}.toString()) {');
    codeBuffer.write(_generateCases('      '));
    codeBuffer.writeln('    }');
    codeBuffer.write('  }');

    return codeBuffer.toString();
  }

  String _generateCases(String inset) {
    StringBuffer caseBuffer = StringBuffer();
    for (var pluralValue in payload) {
      if (pluralValue.isOther) {
        caseBuffer.writeln(
            "${inset}default: return '${_escapeOutput(pluralValue.value)}';");
      } else {
        caseBuffer.writeln(
            "${inset}case '${pluralValue.pluralCode}': return '${_escapeOutput(pluralValue.value)}';");
      }
    }
    return caseBuffer.toString();
  }

  String _generateExtraPrams() {
    List<String> parameters = _calculateAllParameters();
    if (parameters.isEmpty) return '';

    StringBuffer res = StringBuffer();
    res.write('{dynamic ${(parameters.toList()..sort()).join(', dynamic ')}}');
    return res.toString();
  }

  String _generateComments(String inset) {
    StringBuffer res = StringBuffer();
    res.write(
        '$inset/// - ${_generateSelectorComment()}${_generateExtraPramComment()}');
    return res.toString();
  }

  String _generateSelectorComment() {
    StringBuffer res = StringBuffer();
    List<String> selectors = [];
    for (var value in payload) {
      selectors.add(value.pluralCode);
    }
    res.write("$selector in [${selectors.join(', ')}]");
    return res.toString();
  }

  String _generateExtraPramComment() {
    List<String> parameters = _calculateAllParameters();
    if (parameters.isEmpty) return '';

    StringBuffer res = StringBuffer();
    res.write(', parameters : {${(parameters.toList()..sort()).join(', ')}}');
    return res.toString();
  }

  List<String> _calculateAllParameters() {
    Set<String> parameters = Set();
    for (var pluralValue in payload) {
      parameters.addAll(_extractAllParameter(pluralValue.value));
    }
    return parameters.toList()..sort();
  }

  static bool isPluralNode(String key) {
    return PluralValue.pluralRegExp.hasMatch(key);
  }

  bool _hasNoOtherPlural() {
    for (var payload in _payload) {
      if (payload.isOther) return false;
    }
    return true;
  }
}

class PluralValue {
  static String _other = 'Other';
  static Map<String, String> _pluralsMap = {
    _other: 'other',
    'Male': 'male',
    'Female': 'female',
    'Few': 'few',
    'Many': 'many',
    'Zero': '0',
    'One': '1',
    'Two': '2',
  };
  static String _plurals() => _pluralsMap.keys.toList().join('|');
  static RegExp pluralRegExp = RegExp('(\\w+)(${_plurals()})\$');

  String key, plural, value;

  bool get isOther => plural == _other;
  String get pluralCode => _pluralsMap[plural];

  PluralValue(String input, this.value) {
    input = Translation.normalizeKey(input);
    if (pluralRegExp.hasMatch(input)) {
      key = pluralRegExp.firstMatch(input).group(1);
      plural = pluralRegExp.firstMatch(input).group(2);
    }
  }
}

// Private implementation
//final RegExp _parameterRegExp = RegExp(r'(?<!\\)\$\{?(.+?\b)\}?');
final RegExp _parameterRegExp = RegExp(r'(?<!\\)\$\{(.+?\b)\}?');
List<String> _extractAllParameter(String value) {
  return _parameterRegExp
      .allMatches(value)
      .map((param) {
        return _normalizeParameter(param.group(0));
      })
      .toSet()
      .toList()
        ..sort();
}

String _normalizeParameter(String parameter) {
  return parameter //
      .replaceAll(r'$', '')
      .replaceAll(r'{', '')
      .replaceAll(r'}', '');
}

String _escapeOutput(String output) {
  return output.replaceAll("'", r"\'").replaceAll(RegExp(r'\$(?!{)'), r'\$');
}
