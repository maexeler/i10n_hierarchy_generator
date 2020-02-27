import 'package:i10n_hierarchy_generator/src/ast/nodes/all.dart';
import 'package:i10n_hierarchy_generator/src/translation/translation.dart';

///<br>  Key types:
///<br>    simpleKey, pluralKey, commentKey
///<br>
///<br>  Node types:
///<br>    commentNode, simpleNode, parametrizedNode, pluralNode, topLevelNode
///<br>
///<br>  Grammar:
///<br>    translation       ::= topLevelItem [topLevelItem]*
///<br>    topLevelItem      ::= simpleKey  ':' [commentItem | simpleItem | parametrizedItem | pluralItem | topLevelItem]*
///<br>    simpleItem        ::= simpleKey  ':' simpleValue
///<br>    parametrizedItem  ::= simpleKey  ':' parametrizedValue
///<br>    commentItem       ::= commentKey ':' stringValue
///<br>    pluralItem        ::= pluralKey  ':' stringValue
///<br>
///<br>    commentKey        ::= '@' stringValue
///<br>    simpleKey         ::= stringValue
///<br>    pluralKey         ::= simpleKey ['zero', 'one', 'two', 'few', 'many', 'other']
///<br>
///<br>    stringValue       ::= "any string"
///<br>    simpleValue       ::= (stringValue && !parametrizedValue)
///<br>    parametrizedValue ::= stringValue containing('$')
class Parser {

  static CompoundNode parse(Map<String, dynamic> input, String language) {
    TopLevelNode result = TopLevelNode('S', language);
    return _parseItems(result, input, language);
  }

  static bool _isCommentKey(String key) => key.startsWith('@');
  static bool _isPluralKey(String key, value) =>
    value is String && PluralTranslation.isPluralNode(key);
  static bool _isSimpleValue(dynamic value) => value is String && !_isParametrizedValue(value);
  static bool _isParametrizedValue(dynamic value) => value is String && ParametrizedTranslation.isParametrizedNode(value);

  static CompoundNode _parseItems(CompoundNode parent, Map<String, dynamic> input, String language) {
    input.forEach((key, value) {
      // First dispatch by key
      if (_isCommentKey(key)) {
        parent.addCommentNode(key, value, language);} else
      if (_isPluralKey(key, value)) {
        parent.addPluralNode(key, value, language); }
      else { // key must be a simpleKey
        // Now dispatch by value
        if (_isSimpleValue(value))
          parent.addSimpleNode(key, value, language);
        else if (_isParametrizedValue(value))
          parent.addParametrizedNode(key, value, language);
        else {
          CompoundNode subNode = CompoundNode(key, parent);
          parent.addCompoundNode(_parseItems(subNode, value, language));
        }
      }
    });
    return parent;
  }
}