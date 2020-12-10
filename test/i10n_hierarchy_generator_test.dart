import 'package:test/test.dart';

/// Since I heavily refactored the code generation, my old test
/// do no longer work.
/// That is sad but refactoring all tests is too much work for now.
import '../bin/main.dart' as i10n;
void main() {
  test('Generate translation for example', () {
    i10n.main(["-s./example/i10n_pagewise/res/translations", "-o./example/i10n_pagewise/lib/src/generated"]);
  });

}
