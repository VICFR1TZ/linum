
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/utils/parsing/natural_lang_parser.dart';
import 'package:linum/screens/enter_screen/utils/parsing/parser_functions.dart';
import 'package:linum/screens/enter_screen/utils/parsing/tag_parser.dart';
import 'package:linum/screens/enter_screen/utils/structured_parsed_data_builder.dart';


final RegExp splitRegex = RegExp("(?=#)|(?=@)");
final RegExp trimTagRegex = RegExp("(#)|(@)");

class InputParser {
  Filter<Category>? categoryFilter;
  Filter<RepeatInterval>? repeatFilter;
  Filter<ParsableDate>? dateFilter;

  StructuredParsedDataBuilder? _parsedDataBuilder;

  StructuredParsedData parse(String? input) {
    if (input == null || input.isEmpty) {
      return StructuredParsedData("");
    }
    _parsedDataBuilder = StructuredParsedDataBuilder(input);

    final splits = _splitInput(input);

    for (var i = 0; i < splits.length; i++) {
      final split = splits[i];

      if (split.startsWith(trimTagRegex)) {
        _interpretTag(splits[i], input);
        continue;
      }
      NaturalLangParser(_parsedDataBuilder!).parse(split, input);
    }


    final parsedData = _parsedDataBuilder!.build();
    _parsedDataBuilder = null;
    return parsedData;
  }

  List<String> _splitInput(String input) {
    final splits = input.split(splitRegex);

    for (var i = 0; i < splits.length; i++) {
      splits[i] = splits[i].trimRight();
    }
    return splits;
  }

  void _interpretTag(String tag, String fullInput) {
    final trimmedTag = tag.replaceAll(trimTagRegex, "");
    final parsedTag = TagParser().parse(trimmedTag);
    return _handleFlag(
        flag: parsedTag.flag,
        tag: tag,
        fullInput: fullInput,
        parsedTag: parsedTag,
    );
  }

  void _handleFlag({
    required InputFlag? flag,
    required String tag,
    required String fullInput,
    required ParsedTag parsedTag,
  }) {
    switch(flag) {
      case InputFlag.category:
        _handleCategoryFlag(tag, fullInput, parsedTag);
      case InputFlag.date:
        _handleDateFlag(tag, fullInput, parsedTag);
      case InputFlag.repeatInfo:
        _handleRepeatInfoFlag(tag, fullInput, parsedTag);
      default:
        _handleNullFlag(tag, fullInput, parsedTag);
    }
  }

  void _handleNullFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
  ) {
    final categoryResult = _handleCategoryFlag(tag, fullInput, parsedTag);
    if (categoryResult) {
      return;
    }

    final dateResult = _handleDateFlag(tag, fullInput, parsedTag);
    if (dateResult) {
      return;
    }

    final repeatInfoResult = _handleRepeatInfoFlag(tag, fullInput, parsedTag);
    if (repeatInfoResult) {
      return;
    }
  }


  bool _handleCategoryFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
  ) {
    final result = parsedCategory(parsedTag.text, filter: categoryFilter);
    if (result != null) {
      _parsedDataBuilder?.setCategory(
          tag.trimRight(),
          result,
      );
      return true;
    }
    return false;
  }

  bool _handleRepeatInfoFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
      ) {
    final result = parseRepeatConfiguration(parsedTag.text, filter: repeatFilter);
    if (result != null) {
      _parsedDataBuilder?.setRepeatConfiguration(
          tag.trimRight(),
          result,
      );
      return true;
    }
    return false;
  }

  bool _handleDateFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
      ) {
    final result = parsedDate(parsedTag.text, filter: dateFilter);
    if (result != null) {
      _parsedDataBuilder?.setDate(
        tag.trimRight(),
        result,
      );
      return true;
    }
    return false;
  }
}








// TODO: Entering a Category Name first fucks up the parser
