import 'package:flutter/material.dart';
import 'package:linum/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/enter_screen/enums/parsable_date.dart';
import 'package:linum/enter_screen/models/enter_screen_input.dart';
import 'package:linum/enter_screen/models/suggestion.dart';
import 'package:linum/enter_screen/utils/example_string_builder.dart';
import 'package:linum/enter_screen/utils/input_parser.dart';
import 'package:linum/enter_screen/utils/string_from_existing_data.dart';
import 'package:linum/enter_screen/utils/suggestions/insert_suggestion.dart';
import 'package:linum/enter_screen/utils/suggestions/make_suggestions.dart';
import 'package:linum/enter_screen/view_models/enter_screen_view_model.dart';
import 'package:linum/enter_screen/view_models/enter_screen_view_model_data.dart';
import 'package:linum/enter_screen/widgets/suggestion_list.dart';
import 'package:linum/utilities/frontend/media_query_accessors.dart';
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
  OverlayEntry? _overlayEntry;
  Map<String, Suggestion> suggestions = {};
  final exampleStringBuilder = ExampleStringBuilder(
      defaultAmount: 0.00,
      defaultCurrency: "EUR",
      defaultName: "Name",
      defaultCategory: "Keine",
      defaultDate: parsableDateMap[ParsableDate.today]!,
      defaultRepeatInfo: "Keine",
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _viewModel = Provider.of<EnterScreenViewModel>(context, listen: false);
    if (_viewModel.data.withExistingData) {
      final text = generateStringFromExistingData(_viewModel.data);
      final parsed = parse(text);
      exampleStringBuilder.rebuild(parsed);
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
    _overlayEntry?.remove();
    _overlayEntry = null;
    final keyContext = _key.currentContext;
    if (keyContext == null) {
      return;
    }
    final renderBox = keyContext.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = _overlayEntryBuilder(context, size, position);
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _onChange(String text, int cursor) {
    final parsed = parse(text);
    exampleStringBuilder.rebuild(parsed);
    setState(() {
      suggestions = makeSuggestions(text, cursor);
      _rebuildSuggestionList();
    });
    _viewModel.update(EnterScreenViewModelData.fromInput(parsed));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 13,
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
