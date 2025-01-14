//  Statistics Screen - Screen allowing basic as well as complex visualization of transaction statistics
//
//  Author: thebluebaronx (In the Future)
//  Co-Author: n/a

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/widgets/app_bar_action.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/core/design/layout/widgets/top_bar_action_item.dart';
import 'package:linum/generated/translation_keys.g.dart';

/// Page Index: 2
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      actions: [
        AppBarAction.fromPreset(DefaultAction.bugreport),
      ],
      head: 'Stats',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopBarActionItem(
              buttonIcon: Icons.build,
              onPressedAction: () => log('message'),
            ),
            Text(tr(translationKeys.main.labelWip)),
          ],
        ),
      ),
      isInverted: true,
    );
  }
}
