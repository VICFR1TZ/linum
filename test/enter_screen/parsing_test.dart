import 'package:flutter_test/flutter_test.dart';
import 'package:linum/screens/enter_screen/utils/parsing/input_parser.dart';

import '../test_utils/load_localization.dart';
import 'test_inputs.dart';

void main() {
  group("enter_screen_parsing_test", () {
    test("parse text input correctly", () async {
      await loadLocalization();

      final testInputs = generateTestData();

      for (final input in testInputs) {
        final result = InputParser().parse(input.raw);
        final expected = input;
        expect(result, expected);
      }

    });
  });
}
