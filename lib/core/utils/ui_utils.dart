import 'package:flutter/material.dart';

Future<dynamic> navigateTo(BuildContext context, Route<void> route) {
  return Navigator.push(context, route);
}

Future<dynamic> navigateToAndWaitForReturnedValue(
    BuildContext context, Route<void> route) async {
  return await Navigator.push(context, route);
}

void navigateAndClearBackStack(BuildContext context, Route<void> newRoute) {
  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
}

void navigateAndClearTo(
    BuildContext context, Route<void> newRoute, String routeName) {
  Navigator.pushAndRemoveUntil(
      context, newRoute, (route) => route.settings.name == routeName);
}

void popCurrentAndNavigateTo(BuildContext context, Route<void> route) {
  Navigator.pushReplacement(context, route);
}

void clearTo(BuildContext context, String routeName) {
  Navigator.popUntil(context, (route) => route.settings.name == routeName);
}

goBack(BuildContext context, {result}) {
  if (canBack(context)) {
    return Navigator.pop(context, result);
  }
  return null;
}

Future<bool> maybeGoBack(BuildContext context) {
  return Navigator.of(context).maybePop();
}

void goBackAndReturn(BuildContext context, returnObject) {
  Navigator.pop(context, returnObject);
}

bool canBack(BuildContext context) => Navigator.canPop(context);

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void hideSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}
