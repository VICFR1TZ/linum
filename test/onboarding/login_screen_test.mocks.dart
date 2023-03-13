// Mocks generated by Mockito 5.3.2 from annotations
// in linum/test/onboarding/login_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:developer' as _i9;
import 'dart:ui' as _i3;

import 'package:firebase_auth/firebase_auth.dart' as _i8;
import 'package:flutter/material.dart' as _i5;
import 'package:linum/providers/authentication_service.dart' as _i6;
import 'package:linum/providers/onboarding_screen_provider.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [OnboardingScreenProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockOnboardingScreenProvider extends _i1.Mock
    implements _i2.OnboardingScreenProvider {
  @override
  bool get hasPageChanged => (super.noSuchMethod(
        Invocation.getter(#hasPageChanged),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i2.OnboardingPageState get pageState => (super.noSuchMethod(
        Invocation.getter(#pageState),
        returnValue: _i2.OnboardingPageState.none,
        returnValueForMissingStub: _i2.OnboardingPageState.none,
      ) as _i2.OnboardingPageState);
  @override
  String get mailInput => (super.noSuchMethod(
        Invocation.getter(#mailInput),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  void setPageState(_i2.OnboardingPageState? newState) => super.noSuchMethod(
        Invocation.method(
          #setPageState,
          [newState],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setEmailLoginInputSilently(String? newMail) => super.noSuchMethod(
        Invocation.method(
          #setEmailLoginInputSilently,
          [newMail],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}


/// A class which mocks [AuthenticationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationService extends _i1.Mock
    implements _i6.AuthenticationService {
  @override
  _i7.Stream<_i8.User?> get authStateChanges => (super.noSuchMethod(
        Invocation.getter(#authStateChanges),
        returnValue: _i7.Stream<_i8.User?>.empty(),
        returnValueForMissingStub: _i7.Stream<_i8.User?>.empty(),
      ) as _i7.Stream<_i8.User?>);
  @override
  bool get isLoggedIn => (super.noSuchMethod(
        Invocation.getter(#isLoggedIn),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  bool get isInDebugMode => (super.noSuchMethod(
        Invocation.getter(#isInDebugMode),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  String get uid => (super.noSuchMethod(
        Invocation.getter(#uid),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  String get userEmail => (super.noSuchMethod(
        Invocation.getter(#userEmail),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  String get displayName => (super.noSuchMethod(
        Invocation.getter(#displayName),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  bool get isEmailVerified => (super.noSuchMethod(
        Invocation.getter(#isEmailVerified),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i7.Future<void> signIn(
    String? email,
    String? password, {
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
    void Function()? onNotVerified,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signIn,
          [
            email,
            password,
          ],
          {
            #onComplete: onComplete,
            #onError: onError,
            #onNotVerified: onNotVerified,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> signUp(
    String? email,
    String? password, {
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
    required void Function()? onNotVerified,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signUp,
          [
            email,
            password,
          ],
          {
            #onComplete: onComplete,
            #onError: onError,
            #onNotVerified: onNotVerified,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> signInWithGoogle({
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithGoogle,
          [],
          {
            #onComplete: onComplete,
            #onError: onError,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> signInWithApple({
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithApple,
          [],
          {
            #onComplete: onComplete,
            #onError: onError,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> updatePassword(
    String? newPassword, {
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePassword,
          [newPassword],
          {
            #onComplete: onComplete,
            #onError: onError,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> sendVerificationEmail(
    String? email, {
    void Function(String)? onError = _i9.log,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendVerificationEmail,
          [email],
          {#onError: onError},
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> resetPassword(
    String? email, {
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #resetPassword,
          [email],
          {
            #onComplete: onComplete,
            #onError: onError,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> signOut({
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
          {
            #onComplete: onComplete,
            #onError: onError,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> deleteUserAccount({
    void Function(String)? onComplete = _i9.log,
    void Function(String)? onError = _i9.log,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteUserAccount,
          [],
          {
            #onComplete: onComplete,
            #onError: onError,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> setLastMail(String? email) => (super.noSuchMethod(
        Invocation.method(
          #setLastMail,
          [email],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void updateLanguageCode(_i5.BuildContext? context) => super.noSuchMethod(
        Invocation.method(
          #updateLanguageCode,
          [context],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}