import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/categories/utils/translate_category.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/enter_screen_text_editing_controller.dart';
import 'package:linum/screens/enter_screen/utils/example_string_builder.dart';
import 'package:linum/screens/enter_screen/utils/input_parser.dart';
import 'package:linum/screens/enter_screen/utils/string_from_existing_data.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/insert_suggestion.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/make_suggestions.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model_data.dart';
import 'package:linum/screens/enter_screen/widgets/suggestion_list.dart';
import 'package:provider/provider.dart';

class EnterScreenTextField extends StatefulWidget {
  final void Function(EnterScreenInput input)? onInputChange;
  const EnterScreenTextField({super.key, this.onInputChange});

  @override
  State<EnterScreenTextField> createState() => _EnterScreenTextFieldState();
}

class _EnterScreenTextFieldState extends State<EnterScreenTextField> {

  late TextEditingController _controller;
  late EnterScreenViewModel _viewModel;
  final GlobalKey _key = LabeledGlobalKey("text_field");
  late final ExampleStringBuilder exampleStringBuilder;

  Map<String, Suggestion> suggestions = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _viewModel = Provider.of<EnterScreenViewModel>(context, listen: false);

    final accountSettingsService
      = Provider.of<AccountSettingsService>(context, listen: false);

    final defaultCategory = _viewModel.entryType == EntryType.expense
        ? accountSettingsService.getExpenseEntryCategory()
        : accountSettingsService.getIncomeEntryCategory();


    exampleStringBuilder = ExampleStringBuilder(
      defaultAmount: 0.00,
      defaultCurrency: accountSettingsService.getStandardCurrency().name,
      defaultName: "Name",
      defaultCategory: translateCategory(defaultCategory),
      defaultDate: parsableDateMap[ParsableDate.today]!,
      defaultRepeatInfo: "Keine",
    );

    if (_viewModel.data.withExistingData) {
      final text = generateStringFromExistingData(_viewModel.data);
      final parsed = parse(text);
      _controller.text = text;
      exampleStringBuilder.rebuild(parsed);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rebuildSuggestionList() {
    final keyContext = _key.currentContext;
    if (keyContext == null) {
      return;
    }
    final renderBox = keyContext.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final position = renderBox?.localToGlobal(Offset.zero);
    if (size == null || position == null) {
      return;
    }

    _viewModel.setOverlayEntry(_overlayEntryBuilder(context, size, position));
    Overlay.of(context).insert(_viewModel.currentOverlay!);
  }

  void _onChange(String text, int cursor) {
    final parsed = parse(text);
    exampleStringBuilder.rebuild(parsed);
    setState(() {
      suggestions = makeSuggestions(
          text,
          cursor,
          categoryFilter: (category)
            => category.entryType == _viewModel.entryType,
        // TODO: Migh cause problems with Unknown
      );
      _rebuildSuggestionList();
    });
    _viewModel.update(EnterScreenViewModelData.fromInput(parsed), notify: true);
  }

  void _onSuggestionSelection(
    Suggestion suggestion,
    Suggestion? parentSuggestion,
  ) {
    final value = insertSuggestion(
      suggestion: suggestion,
      oldText: _controller.text,
      oldCursor: _controller.selection.base.offset,
      parentSuggestion: parentSuggestion,
    );
    _controller.value = value;
    _onChange(value.text, value.selection.base.offset);
  }

  OverlayEntry _overlayEntryBuilder(
    BuildContext context,
    Size size,
    Offset position,
  ) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        bottom: useScreenHeight(context) - position.dy,
        left: position.dx,
        width: size.width,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: SuggestionList(
            suggestions: suggestions,
            onSelection: _onSuggestionSelection,
          ),
        ),
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 14,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Text(
                  exampleStringBuilder.value.item1,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.transparent,
                  ),
                ),
                Text(
                  exampleStringBuilder.value.item2,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
        ),
        TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 16,
          ),
          key: _key,
          controller: _controller,
          onChanged: (text) {
            _onChange(text, _controller.selection.base.offset);
          },
        )
      ],
    );
  }
}