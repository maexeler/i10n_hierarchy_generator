library i10n_generator;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:i10n_hierarchy_generator/src/ast/nodes/topLevelNode.dart';
import 'package:path/path.dart';

import 'package:i10n_hierarchy_generator/src/ast/parser.dart';

class I10nModule {
  I10nModule(Directory source, [Directory output])
    : assert(source != null),
      assert(source.existsSync(), 'The source folder does not exist.'),
      source = Directory(canonicalize(source.path)),
      output = output != null && output.existsSync() ? output : Directory(join(source.path, 'generated'))
        ..createSync(recursive: true);

  final Directory source;
  final Directory output;

  StreamSubscription<FileSystemEvent> _watchSub;

  void init() => createFileForLanguage('');

  void dispose() => _watchSub?.cancel();

  List<File> get files {
    _checkSourceFolder();

    return source //
      .listSync(recursive: true)
      .whereType<File>()
      .where(_isArb)
      .toList()
      ..sort((File a, File b) => a.path.compareTo(b.path));
  }

  // lang=>string_key=>string_value
  Map<String, Map<String, dynamic>> get values => files
    .asMap()
    .map((_, File it) =>
      MapEntry<String, Map<String, dynamic>>(_languageFromPath(it.path), getLanguageData(it)));

  List<String> get languages => files //
    .map((File it) => basenameWithoutExtension(it.path).split('_').skip(1).join('_'))
    .toList();

  void createOutput() {  // called from main()
    final File generatedFile = File(join(output.path, '$_generatedFileName.dart'));
    var values = this.values;
    TopLevelNode defLng = Parser.parse(values[_defLang], _defLang);

    for (var key in values.keys) {
      if (key != _defLang) {
        defLng.mergeWith(Parser.parse(values[key], key));
      }
    }
    generatedFile.writeAsStringSync(defLng.generateCode());
  }

  StreamSubscription<FileSystemEvent> get watch {  // called from main()
    return _watchSub ??= source
      .watch(events: FileSystemEvent.all, recursive: true)
      .where((FileSystemEvent it) => !it.isDirectory && _isArb(File(it.path)))
      .listen(_onFileChange);
  }

  void _onFileChange(FileSystemEvent event) {
    createOutput();
  }

  File createFileForLanguage(String language) {
    _checkSourceFolder();

    File file = arbFileForLanguage(language);
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsStringSync('{}');
    }
    return file;
  }

  File arbFileForLanguage(String language) {
    if (language.isNotEmpty) language += '_';
    return File(setExtension(absolute(source.path, '${_messageFileName}$language'), '.arb'));
  }

  Map<String, dynamic> getLanguageData(File file) {
    if (!file.existsSync()) {
      throw AssertionError('The file for this language does not exist.');
    }

    String content = file.readAsStringSync();
    if (content.trim().isEmpty) content = '{}';

    try {
      return jsonDecode(content);
    } on FormatException catch (e) {
      var fileName = file.path.split(Platform.pathSeparator).last;
      print('${e.toString()} in $fileName');
      return jsonDecode('{}');
    }
  }

  String _languageFromPath(String path) {
    String lang = basenameWithoutExtension(path).split('_').skip(1).join('_');
    return lang.isEmpty ? _defLang : lang;
  }

  bool _isArb(File it) => extension(it.path) == '.arb' && basenameWithoutExtension(it.path).startsWith('$_messageFileName');

  void _checkSourceFolder() {
    if (!source.existsSync()) {
      throw ArgumentError('The source folder does not exist.');
    }
  }

  static const String _defLang = 'defLang';
  static const String _messageFileName = 'messages';
  static const String _generatedFileName = 'i10n_hierarchy';
}
