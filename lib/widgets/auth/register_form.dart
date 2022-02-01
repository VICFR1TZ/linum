import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _mailController = TextEditingController();
  final _passController = TextEditingController();

  late final Function signUp;
  bool _agbCheck = false;
  bool _agbNullCheck = false;

  @override
  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);
    UserAlert userAlert = UserAlert(context: context);

    void signUp(String _mail, String _pass) {
      auth.signUp(_mail, _pass, onError: userAlert.showMyDialog);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('onboarding_screen/register-lip-title'),
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.translate(
                              'onboarding_screen/register-email-hintlabel'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                        onSubmitted: (_) => {
                          setState(
                            () {
                              signUp(
                                  _mailController.text, _passController.text);
                            },
                          )
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.translate(
                              'onboarding_screen/register-password-hintlabel'),
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
                height: proportionateScreenHeight(16),
              ),
              CheckboxListTile(
                title: Text(
                    'Ich habe die AGB und die Erklärung zum Datenschutz gelesen und akzeptiere sie.',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                value: _agbCheck,
                onChanged: (newVal) {
                  setState(() {
                    _agbCheck = newVal!;
                    newVal == true
                        ? _agbNullCheck = false
                        : _agbNullCheck = true;
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
                checkColor: Theme.of(context).colorScheme.onPrimary,
                activeColor: Theme.of(context).colorScheme.primaryVariant,
                secondary: Icon(Icons.verified_user_rounded),
                visualDensity: VisualDensity(horizontal: -4, vertical: 0),
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
              Text(
                _agbNullCheck
                    ? 'Sie müssen die AGB akzeptieren, bevor Sie sich registrieren können.'
                    : '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold),
              ),
              GradientButton(
                increaseHeightBy: proportionateScreenHeight(16),
                child: Text(
                  AppLocalizations.of(context)!.translate(
                      'onboarding_screen/register-lip-signup-button'),
                  style: Theme.of(context).textTheme.button,
                ),
                callback: _agbCheck
                    ? () => {
                          setState(
                            () {
                              signUp(
                                  _mailController.text, _passController.text);
                            },
                          )
                        }
                    : () => setState(() {
                          _agbNullCheck = true;
                        }),
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

// SAVE THIS SPACE FOR ALTERNATE SIGNUP FUNCTIONS

              // OutlinedButton(
              //   //to-do: implement this functionality
              //   onPressed: null,
              //   child: Text(
              //     AppLocalizations.of(context)!.translate(
              //         'onboarding_screen/login-lip-forgot-password-button'),
              //     style: Theme.of(context).textTheme.button?.copyWith(
              //         color: Theme.of(context).colorScheme.onSurface),
              //   ),
              //   style: OutlinedButton.styleFrom(
              //     elevation: 8,
              //     shadowColor: Theme.of(context).colorScheme.onBackground,
              //     minimumSize: Size(
              //       double.infinity,
              //       proportionateScreenHeight(64),
              //     ),
              //     backgroundColor: Theme.of(context).colorScheme.background,
              //     side: BorderSide(
              //       width: 2,
              //       color: Theme.of(context).colorScheme.primary,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
