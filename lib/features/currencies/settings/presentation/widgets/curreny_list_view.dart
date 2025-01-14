import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/features/currencies/core/presentation/widgets/currency_list_tile.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:provider/provider.dart';

class CurrencyListView extends StatelessWidget {
  final currencies = standardCurrencies.values.toList();

  CurrencyListView();

  @override
  Widget build(BuildContext context) {
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
          return Consumer<ICurrencySettingsService>(
            builder: (context, settings, _) {
              return CurrencyListTile(
                currency: currency,
                selected: currency.name == settings.getStandardCurrency().name,
                onTap: () {
                  settings.setStandardCurrency(currencies[index]);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
