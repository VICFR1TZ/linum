import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController? _mailController;

  final _passController = TextEditingController();

  bool _mailValidate = false;
  bool _passValidate = false;

  @override
  Widget build(BuildContext context) {
    OnboardingScreenProvider onboardingScreenProvider =
        Provider.of<OnboardingScreenProvider>(context);

    if (onboardingScreenProvider.pageState == 1 &&
        onboardingScreenProvider.hasPageChanged) {
      _mailController = null;
      _passController.clear();
      _mailValidate = false;
      _passValidate = false;
    }

    if (_mailController == null) {
      _mailController =
          TextEditingController(text: onboardingScreenProvider.mailInput);
    }

    AuthenticationService auth = Provider.of<AuthenticationService>(context);
    UserAlert userAlert = UserAlert(context: context);

    void logIn(String _mail, String _pass) {
      auth.signIn(
        _mail,
        _pass,
        onError: userAlert.showMyDialog,
        onNotVerified: () => userAlert.showMyDialog(
          "alertdialog/login-verification/message",
          title: "alertdialog/login-verification/title",
          actionTitle: "alertdialog/login-verification/action",
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('onboarding_screen/login-lip-title'),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onBackground,
                        blurRadius: 20.0,
                        offset: Offset(0, 10),
                      ),
                    ]),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: TextField(
                        controller: _mailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.translate(
                              'onboarding_screen/login-email-hintlabel'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                          errorText: _mailValidate
                              ? AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/login-email-errorlabel')
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: _passController,
                        keyboardType: TextInputType.visiblePassword,
                        onSubmitted: (_) =>
                            logIn(_mailController!.text, _passController.text),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.translate(
                              'onboarding_screen/login-password-hintlabel'),
                          errorText: _passValidate
                              ? AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/login-password-errorlabel')
                              : null,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: proportionateScreenHeight(32),
              ),
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     gradient: LinearGradient(
              //       colors: [
              //         Theme.of(context).colorScheme.primary,
              //         Theme.of(context).colorScheme.surface,
              //       ],
              //     ),
              //   ),
              //   child: Center(
              //     child: Text(
              //       'Einloggen',
              //       style: Theme.of(context).textTheme.button,
              //     ),
              //   ),
              // ),

              GradientButton(
                increaseHeightBy: proportionateScreenHeight(16),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_screen/login-lip-login-button'),
                  style: Theme.of(context).textTheme.button,
                ),
                callback: () {
                  setState(() {
                    _mailController!.text.isEmpty
                        ? _mailValidate = true
                        : _mailValidate = false;
                    _passController.text.isEmpty
                        ? _passValidate = true
                        : _passValidate = false;
                  });

                  if (_mailValidate == false && _passValidate == false) {
                    logIn(_mailController!.text, _passController.text);
                  }
                },
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    createMaterialColor(Color(0xFFC1E695)),
                  ],
                ),
                elevation: 0,
                increaseWidthBy: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              SizedBox(
                height: proportionateScreenHeight(8),
              ),
              ForgotPasswordButton(ProviderKey.ONBOARDING),
            ],
          ),
        ),
      ],
    );
  }
}
