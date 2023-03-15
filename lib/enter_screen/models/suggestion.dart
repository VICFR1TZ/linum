import 'package:linum/enter_screen/enums/input_flag.dart';

class Suggestion {
  final InputFlag? flag;
  final String? label;
  final String? plainText;
  const Suggestion({
    this.label,
    this.plainText,
    this.flag,
  });

  bool get isInputFlag {
    return flag != null;
  }

  String display(String Function(String) translator) {
    if (label != null) {
      return translator(label!);
    }
    return plainText ?? "";
  }
}
