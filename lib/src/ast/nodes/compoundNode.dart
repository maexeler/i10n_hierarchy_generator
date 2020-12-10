import 'package:i10n_hierarchy_generator/src/ast/nodes/all.dart';
import 'package:i10n_hierarchy_generator/src/language/language_helper.dart';
import 'package:i10n_hierarchy_generator/src/ast/nodes/translationNode.dart';
import 'package:i10n_hierarchy_generator/src/translation/translation.dart';
import 'package:i10n_hierarchy_generator/src/code_generation/output_tree.dart';

class CompoundNode extends TranslationNode {
  List<CompoundNode> get compoundNodes => _compoundNodes;

  CompoundNode(String key, CompoundNode parent)
      : _simpleNodes = SimpleNodes(),
        _pluralNodes = PluralNodes(),
        _commentNodes = CommentNodes(),
        _compoundNodes = [],
        _parametrizedNodes = ParametrizedNodes(),
        _textDirection = {},
        super(key, parent);

  void addCommentNode(String key, value, String language) {
    // Check for meta information
    if (key == '@@textDirectionLtr') {
      addTextDirection(language, true);
    } else if (key == '@@textDirectionRtl') {
      addTextDirection(language, false);
    } else if (key == '@@isDefaultLanguage') {
      defaultLanguage = language;
    }

    // Otherwise add it as comment
    else {
      key = key.split('_')[0];
      _commentNodes.add(key.substring(1), value, language);
    }
  }

  void addPluralNode(String key, value, String language) {
    _pluralNodes.add(key, value, language);
  }

  void addSimpleNode(String key, value, String language) {
    _simpleNodes.add(key, value, language);
  }

  void addParametrizedNode(String key, value, String language) {
    _parametrizedNodes.add(key, value, language);
  }

  void addCompoundNode(CompoundNode compoundNode) {
    _compoundNodes.add(compoundNode);
  }

  void merge(CompoundNode other) {
    // no match no merge
    if (key != other.key) return;

    _simpleNodes.merge(other._simpleNodes);
    _pluralNodes.merge(other._pluralNodes);
    _commentNodes.merge(other._commentNodes);
    _parametrizedNodes.merge(other._parametrizedNodes);

    for (var node in _compoundNodes) {
      for (var otherNode in other._compoundNodes) {
        node.merge(otherNode);
      }
    }
  }

  void addTextDirection(String language, bool isLtr) {
    _textDirection[language] = isLtr;
  }

  bool getTextDirection(String language) =>
      _textDirection.containsKey(language) ? _textDirection[language] : true;

  bool hasTextDirection(String language) =>
      _textDirection.containsKey(language);

  String get defaultLanguage => _defaultLanguage;

  set defaultLanguage(String language) =>
      _defaultLanguage = language ?? _defaultLanguage;

  // Private implementation
  SimpleNodes _simpleNodes;
  PluralNodes _pluralNodes;
  CommentNodes _commentNodes;
  List<CompoundNode> _compoundNodes;
  ParametrizedNodes _parametrizedNodes;
  Map<String, bool> _textDirection;
  String _defaultLanguage; // null is OK

  static LanguageTree generateOutputTree(
      CompoundNode fromNode, LanguageWithParent langParent) {
    LanguageTree outputTree =
        LanguageTree(fromNode.key, fromNode.qualifiedClassName, langParent);
    String language = langParent.language;

    if (fromNode.hasTextDirection(language)) {
      outputTree.textDirectionLeftToRight = fromNode.getTextDirection(language);
    }
    outputTree.defaultLocale = fromNode.defaultLanguage;

    outputTree.addComments(
        fromNode._commentNodes.getTranslationsForLanguage(language));
    outputTree.addTranslations(
        fromNode._simpleNodes.getTranslationsForLanguage(language));
    outputTree.addTranslations(
        fromNode._pluralNodes.getTranslationsForLanguage(language));
    outputTree.addTranslations(
        fromNode._parametrizedNodes.getTranslationsForLanguage(language));

    fromNode._compoundNodes.forEach((node) {
      outputTree.addSubNode(generateOutputTree(node, langParent));
    });
    outputTree.postProcess();
    return outputTree;
  }
}

abstract class Nodes<T extends Translation> {
  bool hasLeaveNodes(String language) =>
      _getKeysForLanguage(language).isNotEmpty;

  void add(String key, value, String language);

  void merge(Nodes other) {
    Map<String, Set<String>> keyLanguage = _getKeyLanguage();

    for (var otherItem in other._translations) {
      if (keyLanguage.containsKey(otherItem.key) &&
          !keyLanguage[otherItem.key].contains(otherItem.language)) {
        _translations.add(otherItem);
      }
    }
  }

  Map<String, Set<String>> _getKeyLanguage() {
    Map<String, Set<String>> keyLanguage = {};
    for (var value in _translations) {
      if (!keyLanguage.containsKey(value.key)) {
        keyLanguage[value.key] = Set();
      }
      keyLanguage[value.key].add(value.language);
    }
    return keyLanguage;
  }

  Set<String> _getKeysForLanguage(String language) {
    Set<String> res = Set();
    for (var translation in _translations) {
      if (translation.language == language) {
        res.add(translation.key);
      }
    }
    return res;
  }

  /// return all translations for a given language which have a
  /// default translation too.
  List<Translation> getTranslationsForLanguage(String language) {
    // Eliminate all translations without a default translation
    Set<String> defaultLngKeys = _getKeysForLanguage(defaultLanguage);
    Set<String> languageKeys = _getKeysForLanguage(language);
    languageKeys = defaultLngKeys.intersection(defaultLngKeys);
    return _translations
        .where((translation) =>
            languageKeys.contains(translation.key) &&
            translation.language == language)
        .toList();
  }

  Translation getTranslationFor(String key, String language) {
    return _translations.firstWhere(
        (element) => element.key == key && element.language == language,
        orElse: () => null);
  }

  List<Translation> _translations = [];
}

class SimpleNodes extends Nodes<SimpleTranslation> {
  @override
  void add(String key, value, String language) {
    _translations.add(SimpleTranslation(language, key, value));
  }
}

class PluralNodes extends Nodes<PluralTranslation> {
  /// Add a new PluralTranslation
  ///
  /// If there already exists one with the same key and language,
  /// add the translation to this node, otherwise insert it into the list.
  void add(String key, value, String language) {
    var pluralTranslation = PluralTranslation(language, key, value);
    var keyTranslations = _translations
        .where((translation) =>
            translation.key == pluralTranslation.key &&
            translation.language == pluralTranslation.language)
        .toList();
    if (keyTranslations.isEmpty) {
      _translations.add(pluralTranslation);
    } else {
      for (var value in keyTranslations) {
        (value as PluralTranslation).addPlural(pluralTranslation);
      }
    }
  }
}

class CommentNodes extends Nodes<CommentTranslation> {
  @override
  void add(String key, value, String language) {
    _translations.add(CommentTranslation(language, key, value));
  }
}

class ParametrizedNodes extends Nodes<ParametrizedTranslation> {
  @override
  void add(String key, value, String language) {
    _translations.add(ParametrizedTranslation(language, key, value));
  }
}
