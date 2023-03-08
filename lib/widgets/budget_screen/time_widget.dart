//  Time Widget - Formats Timestamps to a human-readable format
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    required this.displayValue,
    this.isTranslated = false,
    super.key,
  });

  final String displayValue;
  final bool isTranslated;

  @override
  Widget build(BuildContext context) {
    final sizeGuideProvider =
        Provider.of<SizeGuideProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      height: sizeGuideProvider.proportionateScreenHeight(32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          isTranslated
              ? displayValue.toUpperCase()
              : tr(displayValue).toUpperCase(),
          style: Theme.of(context).textTheme.overline?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
