//  Settings Screen Expenses List View - the list view shown inside of the action lip
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron (small)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class ExpensesListView extends StatelessWidget {
  final ActionLipStatusProvider actionLipStatusProvider;
  final AccountSettingsProvider accountSettingsProvider;
  const ExpensesListView(
    this.accountSettingsProvider,
    this.actionLipStatusProvider,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height:
                    proportionateScreenHeightFraction(ScreenFraction.twofifths),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: StandardCategoryExpense.values.length,
                  itemBuilder: (BuildContext context, int indexBuilder) {
                    return ListTile(
                      //leading: Icon(widget.categories[index].icon),
                      leading: Icon(
                        standardExpenseCategories[
                                StandardCategoryExpense.values[indexBuilder]]
                            ?.icon,
                      ),
                      title: Text(
                        tr(standardExpenseCategories[StandardCategoryExpense.values[indexBuilder]]?.label ?? "Category"),
                      ),
                      selected:
                          "StandardCategoryExpense.${accountSettingsProvider.settings["StandardCategoryExpense"] as String? ?? "None"}" ==
                              StandardCategoryExpense.values[indexBuilder]
                                  .toString(),
                      onTap: () {
                        final List<String> stringArr = StandardCategoryExpense
                            .values[indexBuilder]
                            .toString()
                            .split(".");
                        accountSettingsProvider.updateSettings({
                          stringArr[0]: stringArr[1],
                        });
                        actionLipStatusProvider.setActionLipStatus(
                          providerKey: ProviderKey.settings,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}