import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/standard_categories.dart';
import 'package:linum/enter_screen/enter_screen.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';
import 'package:linum/utilities/frontend/translate_catogory.dart';
import 'package:provider/provider.dart';

class SerialTransactionTile extends StatelessWidget {
  final SerialTransaction serialTransaction;
  const SerialTransactionTile({super.key, required this.serialTransaction});

  @override
  Widget build(BuildContext context) {
    final String langCode = context.locale.languageCode;
    final DateFormat serialFormatter = DateFormat('dd.MM.yyyy', langCode);

    return Material(
      child: ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: serialTransaction.amount > 0
              ? Theme.of(context)
              .colorScheme
              .tertiary // FU-TURE INCOME BACKGROUND
              : Theme.of(context).colorScheme.errorContainer,
          child: serialTransaction.amount > 0
              ? Icon(
            standardCategories[serialTransaction.category]?.icon ??
                Icons.error,
            color: Theme.of(context)
                .colorScheme
                .onPrimary, // PRESENT INCOME ICON
          )
              : Icon(
            standardCategories[serialTransaction.category]?.icon ??
                Icons.error,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(
          serialTransaction.name != ""
              ? serialTransaction.name
              : translateCategoryId(
            serialTransaction.category,
            isExpense: serialTransaction.amount <= 0,
          ),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
          "${calculateTimeFrequency(context, serialTransaction)} \nSeit ${serialFormatter.format(serialTransaction.initialTime.toDate())}"
              .toUpperCase(),
          style: Theme.of(context).textTheme.overline,
        ),
        trailing: IconButton(
          splashRadius: 24.0,
          icon: Icon(
            Icons.edit_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return EnterScreen(serialTransaction: serialTransaction);
              },
            ),
          },
        ),
      ),
    );
  }

  String calculateTimeFrequency(
      BuildContext context,
      SerialTransaction serialTransaction,
      ) {
    final int duration = serialTransaction.repeatDuration;
    final RepeatDurationType repeatDurationType =
        serialTransaction.repeatDurationType;
    final settings = Provider.of<AccountSettingsProvider>(context);
    final formattedAmount = CurrencyFormatter(
      context.locale,
      symbol: settings.getStandardCurrency().name,
    ).format(serialTransaction.amount.abs());

    switch (repeatDurationType) {
      case RepeatDurationType.seconds:
      //The following constants represent the seconds equivalent of the respecive timeframes - to make the following if-else clause easier to understand
        const int week = 604800;
        const int day = 86400;

        // If the repeatDuration is on a weekly basis
        if (duration % week == 0) {
          if (duration / week == 1) {
            return "$formattedAmount ${tr('enter_screen.label-repeat-weekly')}";
          }
          return "${tr('listview.label-every')} ${(duration / day).floor()} ${tr('listview.label-weeks')}";
        }

        // If the repeatDuration is on a daily basis
        else if (duration % day == 0) {
          if (duration / day == 1) {
            return "$formattedAmount ${tr('enter_screen.label-repeat-daily')}";
          }
          return "${tr('listview.label-every')} ${(duration / day).floor()} ${tr('listview.label-days')}";
        } else {
          //This should never happen, but just in case (if we forget to cap the repeat duration to at least one day)
          return tr('main.label-error');
        }

    // If the repeatDuration is on a monthly / yearly basis
      case RepeatDurationType.months:
        if (duration % 12 == 0) {
          if (duration / 12 == 1) {
            return "$formattedAmount ${tr('enter_screen.label-repeat-annually')}";
          }
          return "${tr('listview.label-every')} ${(duration / 12).floor()} ${tr('listview.label-years')}";
        }
        if (duration == 1) {
          return "$formattedAmount ${tr('enter_screen.label-repeat-30days')}";
        } else if (duration == 3) {
          return "$formattedAmount ${tr('enter_screen.label-repeat-quarterly')}";
        } else if (duration == 6) {
          return "$formattedAmount ${tr('enter_screen.label-repeat-semiannually')}";
        }
        return "${tr('listview.label-every')} ${(duration / 12).floor()} ${tr('listview.label-months')}";
    }
  }
}