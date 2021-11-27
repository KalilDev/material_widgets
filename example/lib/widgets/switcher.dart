import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisSwitcher extends StatelessWidget {
  final Widget/*!*/ child;
  final SharedAxisTransitionType type;
  final Color color;

  const SharedAxisSwitcher({
    Key key,
    this.type = SharedAxisTransitionType.vertical,
    this.color = Colors.transparent,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        child,
        animation,
        secondaryAnimation,
      ) =>
          SharedAxisTransition(
        transitionType: type,
        fillColor: color,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      ),
      child: child,
    );
  }
}

class FadeThroughSwitcher extends StatelessWidget {
  final Widget/*!*/ child;
  final Color color;

  const FadeThroughSwitcher({
    Key key,
    this.color = Colors.transparent,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        child,
        animation,
        secondaryAnimation,
      ) =>
          FadeThroughTransition(
        fillColor: color,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      ),
      child: child,
    );
  }
}
