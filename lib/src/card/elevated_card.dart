import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/src/card/card_style_card.dart';
import 'package:material_you/material_you.dart';

class ElevatedCard extends CardStyleCard {
  const ElevatedCard({
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
      elevation: _ElevatedCardDefaultElevation(context.elevation),
      mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
      shadowColor: MaterialStateProperty.all(context.monetTheme.neutral[0]),
      stateLayerColor: _ElevatedCardDefaultStateLayerColor(scheme),
      elevationTintColor:
          MaterialStateProperty.all(MD3ElevationLevel.surfaceTint(scheme)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      padding:
          MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0)),
    );
  }

  @override
  CardStyle themeStyleOf(BuildContext context) =>
      ElevatedCardTheme.of(context).style ?? CardStyle();
}

@immutable
class ElevatedCardThemeData with Diagnosticable {
  const ElevatedCardThemeData({this.style});

  final CardStyle style;

  /*static ElevatedCardThemeData lerp(
      ElevatedCardThemeData a, ElevatedCardThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return ElevatedCardThemeData(
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
    return other is ElevatedCardThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<CardStyle>('style', style, defaultValue: null));
  }
}

class ElevatedCardTheme extends InheritedTheme {
  const ElevatedCardTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final ElevatedCardThemeData data;

  static ElevatedCardThemeData of(BuildContext context) {
    final ElevatedCardTheme buttonTheme =
        context.dependOnInheritedWidgetOfExactType<ElevatedCardTheme>();
    return buttonTheme?.data ?? const ElevatedCardThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ElevatedCardTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ElevatedCardTheme oldWidget) =>
      data != oldWidget.data;
}

@immutable
class _ElevatedCardDefaultStateLayerColor extends MaterialStateProperty<Color> {
  _ElevatedCardDefaultStateLayerColor(this.scheme);

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
    if (states.contains(MaterialState.focused)) {
      opacity = 0.24;
    }
    if (states.contains(MaterialState.dragged)) {
      // ??
    }
    return color.withOpacity(opacity);
  }
}

@immutable
class _ElevatedCardDefaultElevation
    extends MaterialStateProperty<MD3ElevationLevel> {
  _ElevatedCardDefaultElevation(this.theme);

  final MD3ElevationTheme theme;

  @override
  MD3ElevationLevel resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return theme.level2;
    }
    if (states.contains(MaterialState.dragged)) {
      return theme.level3;
    }
    return theme.level1;
  }
}

@immutable
class _ElevatedCardDefaultCursor extends MaterialStateProperty<MouseCursor> {
  _ElevatedCardDefaultCursor();

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    return MouseCursor.defer;
  }
}
