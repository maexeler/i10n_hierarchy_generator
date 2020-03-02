abstract class TranslationNode {
  static String normalizeKey(String key) =>
      key != null ? key.substring(0, 1).toLowerCase() + key.substring(1) : null;

  TranslationNode(String key, TranslationNode parent) : _parent = parent {
    this._key = normalizeKey(key);
  }

  String get key => _key;

  TranslationNode get parent => _parent;

  String get className => key[0].toUpperCase() + key.substring(1);
  String get qualifiedClassName =>
      parent == null ? className : parent.qualifiedClassName + className;

  // Private implementation
  String _key;
  TranslationNode _parent;
}
