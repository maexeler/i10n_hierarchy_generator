import 'package:i10n_hierarchy_generator/src/language/language_helper.dart';
import 'package:i10n_hierarchy_generator/src/code_generation/code_templates.dart';
import 'package:i10n_hierarchy_generator/src/translation/translation.dart';

class TopLevelLanguageTree {
  final LanguageTree defaultTree;
  final List<String> languages = [];
  final List<LanguageTree> languageTrees = [];

  TopLevelLanguageTree(this.defaultTree);

  void addTree(LanguageTree tree, String language) {
    languages.add(language);
    languageTrees.add(tree);
  }

  String asCode() {
    StringBuffer out = StringBuffer();
    // First output the WidgetsLocalizations class
    // which contains the translation nodes and
    // the references to the sub-translations
    out.write(headerPart);
    // output the language map for S.forLanguage(String language)
    for (String language in languages)
      out.writeln("    '$language': () => \$${language}_(),");
    out.writeln('  };');
    out.writeln();

    // output translation for the default language
    if (!defaultTree.hasTextDirection) {
      defaultTree.textDirectionLeftToRight = true;
    }
    out.write(defaultTree.generateTranslations());
    // output subclass references for the default language
    out.write(defaultTree.generateSubclassReferences());

    out.write(middlePart);
    // output subclasses  for the default language
    out.write(defaultTree.generateSubclasses());

    // After that, output the code for all other translations.
    for (var tree in languageTrees) {
      out.write(tree.generateCode());
    }
    out.writeln();
    out.writeln();

    // Finally finish the code generation by writing the support code.
    out.write(footerPart1);
    for (String language in languages) {
      LocaleInfo li = LocaleInfo(language);
      String countryCode = li.countryCode ?? '';
      out.writeln('      Locale("${li.languageCode}", "${countryCode}"),');
    }
    out.write(footerPart2);
    for (String language in languages) {
      LocaleInfo li = LocaleInfo(language);
      String casePart = '''
      case "$language":
        S.current = \$${language}_();
        return SynchronousFuture<S>(S.current);''';
      out.writeln(casePart);
    }
    out.write(footerPart3);
    return out.toString();
  }
}

class LanguageTree {
  final String key;
  final String className;
  final LanguageWithParent langParent;
  final LocaleInfo defaultLocaleInfo = LocaleInfo(defaultLanguage);

  LanguageTree(this.key, this.className, this.langParent);

  String _textDirection;
  bool get hasTextDirection => _textDirection != null;
  set textDirectionLeftToRight(bool dirIsLeftToRight) =>
    _textDirection = dirIsLeftToRight ? 'ltr' : 'rtl';

  List<LanguageTree> _subNodes = [];
  final List<Translation> _comments = [];
  final List<Translation> _translations = [];

  void addSubNode(LanguageTree node) => _subNodes.add(node);
  void addComments(List<Translation> comments) => _comments.addAll(comments);
  void addTranslations(List<Translation> translations) => _translations.addAll(translations);

  bool get hasTranslations => _hasTranslations();
  bool get hasNoTranslations => !hasTranslations;

  void postProcess() {
    _removeDeadCode();
  }

  String generateTranslations() {
    StringBuffer out = StringBuffer();
    if (_textDirection != null) {
      out.writeln(
        '  @override TextDirection get textDirection => TextDirection.$_textDirection;');
      out.writeln();
    }
    bool override = !langParent.isDefaultLanguage;

    for (var translation in _translations) {
      var comments = _comments.where((comment) => comment.key == translation.key);
      for (var comment in comments) {
        out.writeln(comment.asCode(false));
      }
      out.writeln(translation.asCode(override));
    }
    return out.toString();
  }

  String generateSubclassReferences()  {
    StringBuffer out = StringBuffer();
    for(var node in _subNodes) {
      var comments = _comments.where((comment) => comment.key == node.key);
      for (var comment in comments) {
        out.writeln(comment.asCode(false));
      }
      String type = '${defaultLocaleInfo.prefix}${node.className}';
      String constructor = '${langParent.prefix}${node.className}();';
      out.writeln('  final $type ${node.key} = $constructor');
    }
    return out.toString();
  }

  String generateSubclasses()  {
    StringBuffer out = StringBuffer();
    if (_subNodes.isNotEmpty) out.writeln();
    for(var node in _subNodes) {
      out.writeln(node.generateCode());
    }
    return out.toString();
  }

  String generateCode() {
    StringBuffer out = StringBuffer();
    String extendsClass = langParent.isDefaultLanguage
      ? '' : 'extends ${langParent.prefixParent}$className ';
    out.writeln(
      'class ${langParent.prefix}$className $extendsClass{');

    out.write(generateTranslations());
    out.write(generateSubclassReferences());
    out.writeln('}');
    out.write(generateSubclasses());
    return out.toString();
  }

  void _removeDeadCode() {
    if(_subNodes.isEmpty) return;
    for (var node in _subNodes) {
      node._removeDeadCode();
    }
    for(int i = 0; i < _subNodes.length; ++i) {
      if (_subNodes[i].hasNoTranslations) {
        _subNodes[i] = null;
      }
    }
    _subNodes = _subNodes.where((node) => node != null).toList();
  }

  bool _hasTranslations() {
    if (_translations.isNotEmpty) return true;
    for (var node in _subNodes) {
      if (node._hasTranslations()) return true;
    }
    return false;
  }
}
