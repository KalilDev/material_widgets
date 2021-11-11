import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/src/card/card_style_card.dart';
import 'package:material_you/material_you.dart';

class FilledCard extends CardStyleCard {
  const FilledCard({
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
      backgroundColor: MaterialStateProperty.all(scheme.surfaceVariant),
      elevation: _FilledCardDefaultElevation(context.elevation),
      mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
      shadowColor: MaterialStateProperty.all(context.monetTheme.neutral[0]),
      stateLayerColor: _FilledCardDefaultStateLayerColor(scheme),
      elevationTintColor: MaterialStateProperty.all(null),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      padding:
          MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0)),
    );
  }

  @override
  CardStyle themeStyleOf(BuildContext context) =>
      FilledCardTheme.of(context).style ?? CardStyle();
}

@immutable
class FilledCardThemeData with Diagnosticable {
  const FilledCardThemeData({this.style});

  final CardStyle style;

  /*static FilledCardThemeData lerp(
      FilledCardThemeData a, FilledCardThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return FilledCardThemeData(
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
    return other is FilledCardThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<CardStyle>('style', style, defaultValue: null));
  }
}

class FilledCardTheme extends InheritedTheme {
  const FilledCardTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final FilledCardThemeData data;

  static FilledCardThemeData of(BuildContext context) {
    final FilledCardTheme buttonTheme =
        context.dependOnInheritedWidgetOfExactType<FilledCardTheme>();
    return buttonTheme?.data ?? const FilledCardThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FilledCardTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledCardTheme oldWidget) => data != oldWidget.data;
}

@immutable
class _FilledCardDefaultStateLayerColor extends MaterialStateProperty<Color> {
  _FilledCardDefaultStateLayerColor(this.scheme);

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
class _FilledCardDefaultElevation
    extends MaterialStateProperty<MD3ElevationLevel> {
  _FilledCardDefaultElevation(this.theme);

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
class _FilledCardDefaultCursor extends MaterialStateProperty<MouseCursor> {
  _FilledCardDefaultCursor();

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    return MouseCursor.defer;
  }
}
