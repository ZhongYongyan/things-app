import 'package:flutter/widgets.dart';

class NavigatorHolder {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  String _lastRouteName = '';

  Future<T> pushNamed<T extends Object>(
    String routeName, {
    Object arguments,
  }) {
    if (_lastRouteName != routeName) {
      _lastRouteName = routeName;
      return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
    }
  }

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
  }) {
    if (_lastRouteName != routeName) {
      _lastRouteName = routeName;
      return navigatorKey.currentState.pushReplacementNamed(routeName, result: result, arguments: arguments);
    }
  }
}

NavigatorHolder navigatorHolder = NavigatorHolder();
