import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/base_translator.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_text_field_view_model.dart';
import 'package:provider/provider.dart';

class EnterScreenTextField extends StatelessWidget {
  final ParsingFilters? parsingFilters;
  const EnterScreenTextField({
    super.key,
    this.parsingFilters,
  });

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 16,
      letterSpacing: 1.0,
      textBaseline: TextBaseline.alphabetic,
      height: 2.0,
    );

    final locale = context.locale;

    return ChangeNotifierProxyProvider<
        EnterScreenFormViewModel,
        EnterScreenTextFieldViewModel
    >(
      create: (context) => EnterScreenTextFieldViewModel(
          context,
          BaseTranslator(locale.languageCode),
          parsingFilters: parsingFilters,
      ),
      update: (context, formViewModel, textFieldViewModel) {
        if (textFieldViewModel == null) {
          return EnterScreenTextFieldViewModel(
            context,
            BaseTranslator(locale.languageCode),
            parsingFilters: parsingFilters,
          );
        }
        textFieldViewModel.handleUpdate(context);
        return textFieldViewModel;
      },
      builder: (context, _) {
        final textFieldViewModel = context.watch<EnterScreenTextFieldViewModel>();
        return TextFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            errorMaxLines: 2,
          ),
          validator: _validateInput,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorHeight: baseTextStyle.fontSize! + textFieldViewModel.textController.cursorHeight,
          autofocus: true,
          style: baseTextStyle,
          key: textFieldViewModel.textFieldKey,
          controller: textFieldViewModel.textController,
          textAlignVertical: TextAlignVertical.bottom,
          autovalidateMode: AutovalidateMode.always,
        );
      },
    );
  }

  String? _validateInput(String? value){
    if(value == null || value.isEmpty) return null;
    if(!value.startsWith(RegExp(r'\d'))) {
      return tr(translationKeys.enterScreen.addAmount.parserStartWithAmountError);
    }
    return null;
  }
}
// TODO maybe use another provider for this
