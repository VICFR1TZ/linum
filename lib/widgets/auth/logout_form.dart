import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
import 'package:provider/provider.dart';

class LogoutForm extends StatefulWidget {
  @override
  State<LogoutForm> createState() => _LogoutFormState();
}

class _LogoutFormState extends State<LogoutForm> {
  @override
  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);

    return Column(
      children: [
        GradientButton(
          increaseHeightBy: proportionateScreenHeight(16),
          child: Text(
            AppLocalizations.of(context)!
                .translate('settings_screen/system-settings/button-signout'),
            style: Theme.of(context).textTheme.button,
          ),
          callback: () => {
            setState(
              () {
                auth.signOut();
              },
            )
          },
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              createMaterialColor(Color(0xFFC1E695)),
            ],
          ),
          elevation: 0,
          increaseWidthBy: double.infinity,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        SizedBox(
          height: proportionateScreenHeight(8),
        ),
      ],
    );
  }
}
