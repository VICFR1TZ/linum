//  MainRouterDelegate - Handles routing and exchanges Pages based on current route
//
//  Author: damattl
//

import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/design/layout/loading_scaffold.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/core/navigation/main_routes_extensions.dart';
import 'package:linum/core/navigation/main_transition_delegate.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:linum/screens/onboarding_screen/onboarding_screen.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MainRouterDelegate extends RouterDelegate<MainRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoute> {
  @override
  late final GlobalKey<NavigatorState> navigatorKey;
  late final Logger logger;

  MainRouterDelegate() {
    navigatorKey = GlobalKey<NavigatorState>();
    logger = Logger();
  }

  Page? _replacedRoute;
  final _pageStack = <Page>[];

  final Map<String, void Function()> _onPopListeners = {};
  void Function()? _onPopOverwrite;
  /* MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch(routeSettings.name) {

    }
  } */
  void setOnPopOverwrite(void Function()? onPop) {
    _onPopOverwrite = onPop;
  }

  void addOnPopListener(String name, void Function() onPop) {
    _onPopListeners[name] = onPop;
  }

  void removeOnPopListener(String name) {
    _onPopListeners.remove(name);
  }

  List<Page> _buildPageStackUnauthorized() {
    return <Page>[
      MaterialPage(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<OnboardingScreenViewModel>(
              create: (_) => OnboardingScreenViewModel(),
            ),
          ],
          child: const OnboardingPage(),
        ),
      ),
    ];
  }

  List<Page> _buildPinCodeStack(PinCodeService pinCodeProvider) {
    final pinCodeStack = <Page>[
      mainRoutes.pageFromRoute(MainRoute.lock),
    ];
    pinCodeProvider.setRecallIntent();
    return List.of(pinCodeStack);
  }

  List<Page> _buildPageStackAuthorized(BuildContext context) {
    final PinCodeService pinCodeProvider =
        context.watch<PinCodeService>();
    if (_pageStack.isEmpty) {
      _pageStack.add(mainRoutes.pageFromRoute(MainRoute.home));
    }
    if (pinCodeProvider.pinSet && !pinCodeProvider.sessionIsSafe) {
      return _buildPinCodeStack(pinCodeProvider);
    }

    return List.of(_pageStack);
  }

  List<Page> _buildPageStack(BuildContext context) {
    final AuthenticationService auth =
        context.watch<AuthenticationService>();
    if (auth.isLoggedIn) {
      return _buildPageStackAuthorized(context);
    } else {
      return _buildPageStackUnauthorized();
    }
  }

  Navigator _buildNavigator(BuildContext context) {
    final transitionDelegate = MainTransitionDelegate();
    return Navigator(
      key: navigatorKey,
      // Add TransitionDelegate here
      pages: _buildPageStack(context),
      transitionDelegate: transitionDelegate,
      onPopPage: _onPopPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinCodeProvider =
        context.read<PinCodeService>();
    if (pinCodeProvider.pinSetStillLoading) {
      return FutureBuilder(
        future: pinCodeProvider.initializeIsPINSet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildNavigator(context);
          }
          return const LoadingScaffold();
        },
      );
    } else {
      return _buildNavigator(context);
    }
  }

  bool _onPopPage(Route route, dynamic result) {
    logger.i("Route: $route");
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  /// Pop the current route from the MainRouter's Stack.
  /// If there is only one route left, the app will close.
  /// TODO: Discuss if this is the wanted behaviour
  @override
  Future<bool> popRoute() async {
    logger.i("Stack: $_pageStack");

    if (_onPopOverwrite != null) {
      _onPopOverwrite!.call();
      _onPopOverwrite = null;
      return Future.value(true);
    }

    for (final listener in _onPopListeners.values) {
      listener();
    }

    if (_replacedRoute != null) {
      _pageStack.removeLast();
      _pageStack.add(_replacedRoute!);
      _replacedRoute = null;
      return Future.value(true);
    }

    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      notifyListeners();

      return Future.value(true);
    }
    return Future.value(true); // TODO: Check if this makes sense
  }

  /// Push a route to the MainRouter's Stack.
  /// Notifies all listening widgets.
  void pushRoute<T>(MainRoute route, {T? settings}) {
    _pageStack.add(mainRoutes.pageFromRoute(route, settings: settings));
    notifyListeners();
  }

  /// Replace the last route on the MainRouter's Stack with a new one.
  /// Notifies all listening widgets.
  void replaceLastRoute(MainRoute route, {bool rememberReplacedRoute = false}) {
    final replaced = _pageStack.removeLast();
    _replacedRoute = rememberReplacedRoute ? replaced : null;
    _pageStack.add(mainRoutes.pageFromRoute(route));

    notifyListeners();
  }

  /// Rebuild the current stack.
  /// Use this function to update the UI after a change in the apps state.
  /// (For example after the user signed out)
  void rebuild() {
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MainRoute route) async {}
}
