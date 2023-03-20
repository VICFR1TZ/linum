import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/widgets/currency_list_tile.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:provider/provider.dart';

class CurrencyListView extends StatelessWidget {
  final currencies = standardCurrencies.values.toList();

  CurrencyListView();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AccountSettingsService>(context);
    final actionLipStatus = Provider.of<ActionLipViewModel>(context);
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: context.proportionateScreenHeightFraction(ScreenFraction.onefifth),
        ),
        shrinkWrap: true,
        itemCount: currencies.length,
        itemBuilder: (BuildContext context, int index) {
          final currency = currencies[index];
          return CurrencyListTile(
            currency: currency,
            selected: currency.name == settings.getStandardCurrency().name,
            onTap: () {
              settings.setStandardCurrency(currencies[index]);
              actionLipStatus.setActionLipStatus(
                screenKey: ScreenKey.settings,
                status: ActionLipVisibility.hidden,
              );
            },
          );
        },
      ),
    );
  }
}
