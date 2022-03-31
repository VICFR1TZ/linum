import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/repeatable_change_type.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/widgets/enter_screen/enter_screen_listviewbuilder.dart';
import 'package:linum/widgets/enter_screen/enter_screen_top_input_field.dart';
import 'package:linum/widgets/top_bar_action_item.dart';
import 'package:provider/provider.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  @override
  Widget build(BuildContext context) {
    final EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    //  AccountSettingsProvider accountSettingsProvider =
    //       Provider.of<AccountSettingsProvider>(context);

    //to format the date time it has to be parsed to a string, get formatted
    //and get parsed back to a date time
    final String selectedDateStringFormatted =
        enterScreenProvider.selectedDate.toString().split(' ')[0];
    final DateTime selectedDateDateTimeFormatted =
        DateTime.parse(selectedDateStringFormatted);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: BackButton(),
        // ),
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //the top, green lip
            const EnterScreenTopInputField(),
            enterScreenProvider.isTransaction
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TopBarActionItem(
                          buttonIcon: Icons.build,
                          onPressedAction: () => {},
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('main/label-wip'),
                        ),
                      ],
                    ),
                  )
                : EnterScreenListViewBuilder(),
            Expanded(
              child: Container(color: Theme.of(context).colorScheme.background),
            ),
            /*enterScreenProvider.editMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          balanceDataProvider.removeSingleBalance(arrayElement["id"])
                        },
                        child: Text("Delete"),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.error),
                            textStyle: Theme.of(context).textTheme.button,
                            primary: Theme.of(context).colorScheme.background,
                            onPrimary: Theme.of(context).colorScheme.error,
                            onSurface: Colors.white,
                            fixedSize: Size(proportionateScreenWidth(300),
                                proportionateScreenHeight(40))),
                      ),
                    ],
                  )
                : SizedBox(height: 0),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.button,
                    primary: Theme.of(context).colorScheme.primary,
                    onPrimary: Theme.of(context).colorScheme.background,
                    onSurface: Colors.white,
                    fixedSize: Size(
                      proportionateScreenWidth(300),
                      proportionateScreenHeight(40),
                    ),
                  ),
                  onPressed: () {
                    if (enterScreenProvider.isIncome &&
                        _amountChooser(enterScreenProvider) <= 0) {
                      showAlertDialog(context, enterScreenProvider);
                      log(
                        "amount was to low: ${_amountChooser(enterScreenProvider)}",
                      );
                      return;
                    }
                    Navigator.of(context).pop();

                    if (enterScreenProvider.editMode) {
                      if (enterScreenProvider.repeatId == null) {
                        balanceDataProvider.updateSingleBalance(
                          id: enterScreenProvider.formerId ?? "",
                          amount: _amountChooser(enterScreenProvider),
                          category: enterScreenProvider.category,
                          currency: "EUR",
                          name: enterScreenProvider.name,
                          time: Timestamp.fromDate(
                            selectedDateDateTimeFormatted,
                          ),
                        );
                      } else {
                        final UserAlert userAlert = UserAlert(context: context);

                        // open popup
                        balanceDataProvider.updateRepeatedBalance(
                          id: enterScreenProvider.repeatId!,
                          changeType: RepeatableChangeType.onlyThisOne,
                          amount: _amountChooser(enterScreenProvider),
                          category: enterScreenProvider.category,
                          currency: "EUR",
                          name: enterScreenProvider.name,
                          time: Timestamp.fromDate(
                            selectedDateDateTimeFormatted,
                          ),
                        );
                      }
                    } else {
                      if (enterScreenProvider.repeatDuration == null ||
                          enterScreenProvider.repeatDurationTyp == null) {
                        balanceDataProvider.addSingleBalance(
                          SingleBalanceData(
                            amount: _amountChooser(enterScreenProvider),
                            category: enterScreenProvider.category,
                            currency: "EUR",
                            name: enterScreenProvider.name,
                            time: Timestamp.fromDate(
                              DateTime(
                                selectedDateDateTimeFormatted.year,
                                selectedDateDateTimeFormatted.month,
                                selectedDateDateTimeFormatted.day,
                                selectedDateDateTimeFormatted.hour != 0
                                    ? selectedDateDateTimeFormatted.hour
                                    : DateTime.now().hour,
                                selectedDateDateTimeFormatted.minute != 0
                                    ? selectedDateDateTimeFormatted.minute
                                    : DateTime.now().minute,
                                selectedDateDateTimeFormatted.second != 0
                                    ? selectedDateDateTimeFormatted.second
                                    : DateTime.now().second,
                              ),
                            ),
                          ),
                        );
                      } else {
                        balanceDataProvider.addRepeatedBalance(
                          RepeatBalanceData(
                            amount: _amountChooser(enterScreenProvider),
                            category: enterScreenProvider.category,
                            currency: "EUR",
                            name: enterScreenProvider.name,
                            initialTime: Timestamp.fromDate(
                              DateTime(
                                selectedDateDateTimeFormatted.year,
                                selectedDateDateTimeFormatted.month,
                                selectedDateDateTimeFormatted.day,
                                selectedDateDateTimeFormatted.hour != 0
                                    ? selectedDateDateTimeFormatted.hour
                                    : DateTime.now().hour,
                                selectedDateDateTimeFormatted.minute != 0
                                    ? selectedDateDateTimeFormatted.minute
                                    : DateTime.now().minute,
                                selectedDateDateTimeFormatted.second != 0
                                    ? selectedDateDateTimeFormatted.second
                                    : DateTime.now().second,
                              ),
                            ),
                            repeatDuration: enterScreenProvider.repeatDuration!,
                            repeatDurationType:
                                enterScreenProvider.repeatDurationTyp!,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('enter_screen/button-save-entry'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  //if the amount is entered in expenses, it's set to the negative equivalent if
  //the user did not accidentally press the minus
  num _amountChooser(EnterScreenProvider enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      if (enterScreenProvider.amount < 0) {
        return enterScreenProvider.amount;
      } else {
        return -enterScreenProvider.amount;
      }
    } else {
      return enterScreenProvider.amount;
    }
  }

  void showAlertDialog(
    BuildContext context,
    EnterScreenProvider enterScreenProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate(
              'enter_screen/add-amount/dialog-label-title-expenses',
            ),
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!
                    .translate('enter_screen/add-amount/dialog-label-title'),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
