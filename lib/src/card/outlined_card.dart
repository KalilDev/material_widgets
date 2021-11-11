import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/src/card/card_style_card.dart';
import 'package:material_you/material_you.dart';

class OutlinedCard extends CardStyleCard {
  const OutlinedCard({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    FocusNode focusNode,
    CardStyle style,
    @required Widget child,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          focusNode: focusNode,
          style: style,
          child: child,
        );

  @override
  CardStyle defaultStyleOf(BuildContext context) {
    final scheme = context.colorScheme;
    return CardStyle(
      backgroundColor: MaterialStateProperty.all(scheme.surface),
      elevation: _OutlinedCardDefaultElevation(context.elevation),
      mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
      shadowColor: MaterialStateProperty.all(context.monetTheme.neutral[0]),
      stateLayerColor: _OutlinedCardDefaultStateLayerColor(scheme),
      elevationTintColor:
          MaterialStateProperty.all(MD3ElevationLevel.surfaceTint(scheme)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            width: 1,
            color: scheme.outline,
          ),
        ),
      ),
      padding:
          MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0)),
    );
  }

  @override
  CardStyle themeStyleOf(BuildContext context) =>
      OutlinedCardTheme.of(context).style ?? CardStyle();
}

@immutable
class OutlinedCardThemeData with Diagnosticable {
  const OutlinedCardThemeData({this.style});

  final CardStyle style;

  /*static OutlinedCardThemeData lerp(
      OutlinedCardThemeData a, OutlinedCardThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return OutlinedCardThemeData(
      style: CardStyle.lerp(a?.style, b?.style, t),
    );
  }*/

  @override
  int get hashCode {
    return style.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is OutlinedCardThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<CardStyle>('style', style, defaultValue: null));
  }
}

class OutlinedCardTheme extends InheritedTheme {
  const OutlinedCardTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final OutlinedCardThemeData data;

  static OutlinedCardThemeData of(BuildContext context) {
    final OutlinedCardTheme buttonTheme =
        context.dependOnInheritedWidgetOfExactType<OutlinedCardTheme>();
    return buttonTheme?.data ?? const OutlinedCardThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return OutlinedCardTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(OutlinedCardTheme oldWidget) =>
      data != oldWidget.data;
}

@immutable
class _OutlinedCardDefaultStateLayerColor extends MaterialStateProperty<Color> {
  _OutlinedCardDefaultStateLayerColor(this.scheme);

  final MonetColorScheme scheme;

  @override
  Color resolve(Set<MaterialState> states) {
    final color = scheme.onSurface;
    double opacity = 0.0;
    if (states.contains(MaterialState.pressed)) {
      opacity = 0.24;
    }
    if (states.contains(MaterialState.hovered)) {
      opacity = 0.08;
    }
    if (states.contains(MaterialState.dragged)) {
      // ??
    }
    return color.withOpacity(opacity);
  }
}

@immutable
class _OutlinedCardDefaultElevation
    extends MaterialStateProperty<MD3ElevationLevel> {
  _OutlinedCardDefaultElevation(this.theme);

  final MD3ElevationTheme theme;

  @override
  MD3ElevationLevel resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered) ||
        states.contains(MaterialState.focused)) {
      return theme.level1;
    }
    if (states.contains(MaterialState.dragged)) {
      return theme.level3;
    }
    return theme.level0;
  }
}

@immutable
class _OutlinedCardDefaultCursor extends MaterialStateProperty<MouseCursor> {
  _OutlinedCardDefaultCursor();

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    return MouseCursor.defer;
  }
}
