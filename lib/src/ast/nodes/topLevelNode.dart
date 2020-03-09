import 'package:i10n_hierarchy_generator/src/language/language_helper.dart';
import 'package:i10n_hierarchy_generator/src/ast/nodes/compoundNode.dart';
import 'package:i10n_hierarchy_generator/src/code_generation/output_tree.dart';

/// TopLevelNodes aggregate [CompoundNode]s for all languages
///
/// There is one special TopLevelNode, the one for the [defaultLanguage].
/// When two or more TopLevelNodes are merged, only the the parts given
/// by the default language are incorporated into the merged version.
class TopLevelNode extends CompoundNode {
  static final String topLevelClassName = 'S';

  LanguageHierarchy _languageHierarchy = LanguageHierarchy();

  TopLevelNode(String key, String language) : super(key, null) {
    _languageHierarchy.add(language);
  }

  @override
  String get qualifiedClassName => '';

  void mergeWith(TopLevelNode other) {
    _languageHierarchy.merge(other._languageHierarchy);

    for (var lngParent in other._languageHierarchy.languages) {
      String language = lngParent.language;
      if (other.hasTextDirection(language)) {
        addTextDirection(language, other.getTextDirection(language));
      }
    }
    this.defaultLanguage = other.defaultLanguage;
    merge(other);
  }

  String generateCode() {
    TopLevelLanguageTree topLevelTree = TopLevelLanguageTree(
        CompoundNode.generateOutputTree(this, _languageHierarchy.defLanguage));
    for (LanguageWithParent language in _languageHierarchy.languages) {
      if (language.isDefaultLanguage) continue;
      topLevelTree.addTree(
          CompoundNode.generateOutputTree(this, language), language.language);
    }
    return topLevelTree.asCode();
  }
}
