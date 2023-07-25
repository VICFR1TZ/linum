import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';

TextIndices? getTextIndices(
    String? substring,
    String raw, {
      int startIndex = 0,
}) {
      if (substring == null) {
            return null;
      }
      final start = raw.indexOf(substring);
      final end = start + substring.length;
      return (start: start + startIndex, end: end + startIndex);
}
