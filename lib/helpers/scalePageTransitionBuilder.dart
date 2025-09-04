import 'package:flutter/material.dart';

class scalePageTransitionBuilder extends PageTransitionsBuilder {
  const scalePageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutQuart, // soft and elegant
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}
