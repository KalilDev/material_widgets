import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

extension GallerySchemeContext on BuildContext {
  GalleryCustomColorScheme get galleryColors =>
      InheritedAppCustomColorScheme.maybeOf<GalleryCustomColorScheme>(this)!;
}

class NamedCustomColorScheme {
  final CustomColorScheme? scheme;
  final String name;

  const NamedCustomColorScheme(this.scheme, this.name);
}

class GalleryCustomColorScheme
    extends AppCustomColorScheme<GalleryCustomColorScheme> with Diagnosticable {
  final CustomColorScheme yellow;
  final CustomColorScheme pink;
  final CustomColorScheme blue;
  final CustomColorScheme darkBlue;
  final CustomColorScheme lime;
  final CustomColorScheme green;
  final CustomColorScheme red;

  const GalleryCustomColorScheme({
    required this.yellow,
    required this.pink,
    required this.blue,
    required this.darkBlue,
    required this.lime,
    required this.green,
    required this.red,
  });

  List<NamedCustomColorScheme> get named => [
        NamedCustomColorScheme(null, 'Terciaria'),
        NamedCustomColorScheme(yellow, 'Amarelo'),
        NamedCustomColorScheme(pink, 'Rosa'),
        NamedCustomColorScheme(blue, 'Ciano'),
        NamedCustomColorScheme(darkBlue, 'Azul'),
        NamedCustomColorScheme(lime, 'Lima'),
        NamedCustomColorScheme(green, 'Verde'),
        NamedCustomColorScheme(red, 'Vermelho'),
      ];

  @override
  GalleryCustomColorScheme lerpWith(GalleryCustomColorScheme b, double t) =>
      lerp(this, b, t);

  @override
  int get hashCode => Object.hashAll([
        yellow,
        pink,
        blue,
        darkBlue,
        lime,
        green,
        red,
      ]);

  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! GalleryCustomColorScheme) {
      return false;
    }
    return true &&
        yellow == other.yellow &&
        pink == other.pink &&
        blue == other.blue &&
        darkBlue == other.darkBlue &&
        lime == other.lime &&
        green == other.green &&
        red == other.red;
  }

  GalleryCustomColorScheme copyWith({
    CustomColorScheme? yellow,
    CustomColorScheme? pink,
    CustomColorScheme? blue,
    CustomColorScheme? darkBlue,
    CustomColorScheme? lime,
    CustomColorScheme? green,
    CustomColorScheme? red,
  }) =>
      GalleryCustomColorScheme(
        yellow: yellow ?? this.yellow,
        pink: pink ?? this.pink,
        blue: blue ?? this.blue,
        darkBlue: darkBlue ?? this.darkBlue,
        lime: lime ?? this.lime,
        green: green ?? this.green,
        red: red ?? this.red,
      );

  static GalleryCustomColorScheme lerp(
    GalleryCustomColorScheme a,
    GalleryCustomColorScheme b,
    double t,
  ) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return GalleryCustomColorScheme(
      yellow: CustomColorScheme.lerp(a.yellow, b.yellow, t),
      pink: CustomColorScheme.lerp(a.pink, b.pink, t),
      blue: CustomColorScheme.lerp(a.blue, b.blue, t),
      darkBlue: CustomColorScheme.lerp(a.darkBlue, b.darkBlue, t),
      lime: CustomColorScheme.lerp(a.lime, b.lime, t),
      green: CustomColorScheme.lerp(a.green, b.green, t),
      red: CustomColorScheme.lerp(a.red, b.red, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CustomColorScheme>('yellow', yellow));
    properties.add(DiagnosticsProperty<CustomColorScheme>('pink', pink));
    properties.add(DiagnosticsProperty<CustomColorScheme>('blue', blue));
    properties
        .add(DiagnosticsProperty<CustomColorScheme>('darkBlue', darkBlue));
    properties.add(DiagnosticsProperty<CustomColorScheme>('lime', lime));
    properties.add(DiagnosticsProperty<CustomColorScheme>('green', green));
    properties.add(DiagnosticsProperty<CustomColorScheme>('red', red));
  }
}

class GalleryCustomColorTheme extends AppCustomColorTheme<
    GalleryCustomColorScheme, GalleryCustomColorTheme> with Diagnosticable {
  final CustomColorTheme yellow;
  final CustomColorTheme pink;
  final CustomColorTheme blue;
  final CustomColorTheme darkBlue;
  final CustomColorTheme lime;
  final CustomColorTheme green;
  final CustomColorTheme red;

  const GalleryCustomColorTheme({
    required this.yellow,
    required this.pink,
    required this.blue,
    required this.darkBlue,
    required this.lime,
    required this.green,
    required this.red,
  });

  static const kYellowSeed = Color(0xFFf5f50c);
  static const kPinkSeed = Color(0xFFf50ced);
  static const kBlueSeed = Color(0xFF0cedf5);
  static const kDarkBlueSeed = Color(0xFF200cf5);
  static const kLimeSeed = Color(0xFF0cf527);
  static const kGreenSeed = Color(0xFF005448);
  static const kRedSeed = Color(0xFFFF0000);

  static GalleryCustomColorTheme harmonized(MonetTheme theme) =>
      GalleryCustomColorTheme(
        yellow: theme.harmonizedCustomColorTheme(kYellowSeed),
        pink: theme.harmonizedCustomColorTheme(kPinkSeed),
        blue: theme.harmonizedCustomColorTheme(kBlueSeed),
        darkBlue: theme.harmonizedCustomColorTheme(kDarkBlueSeed),
        lime: theme.harmonizedCustomColorTheme(kLimeSeed),
        green: theme.harmonizedCustomColorTheme(kGreenSeed),
        red: theme.harmonizedCustomColorTheme(kRedSeed),
      );

  @override
  GalleryCustomColorScheme get light => GalleryCustomColorScheme(
        yellow: yellow.light,
        pink: pink.light,
        blue: blue.light,
        darkBlue: darkBlue.light,
        lime: lime.light,
        green: green.light,
        red: red.light,
      );

  @override
  GalleryCustomColorScheme get dark => GalleryCustomColorScheme(
        yellow: yellow.dark,
        pink: pink.dark,
        blue: blue.dark,
        darkBlue: darkBlue.dark,
        lime: lime.dark,
        green: green.dark,
        red: red.dark,
      );

  @override
  GalleryCustomColorTheme lerpWith(GalleryCustomColorTheme b, double t) =>
      lerp(this, b, t);

  @override
  int get hashCode => Object.hashAll([
        yellow,
        pink,
        blue,
        darkBlue,
        lime,
        green,
        red,
      ]);

  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! GalleryCustomColorTheme) {
      return false;
    }
    return true &&
        yellow == other.yellow &&
        pink == other.pink &&
        blue == other.blue &&
        darkBlue == other.darkBlue &&
        lime == other.lime &&
        green == other.green &&
        red == other.red;
  }

  GalleryCustomColorTheme copyWith({
    CustomColorTheme? yellow,
    CustomColorTheme? pink,
    CustomColorTheme? blue,
    CustomColorTheme? darkBlue,
    CustomColorTheme? lime,
    CustomColorTheme? green,
    CustomColorTheme? red,
  }) =>
      GalleryCustomColorTheme(
        yellow: yellow ?? this.yellow,
        pink: pink ?? this.pink,
        blue: blue ?? this.blue,
        darkBlue: darkBlue ?? this.darkBlue,
        lime: lime ?? this.lime,
        green: green ?? this.green,
        red: red ?? this.red,
      );

  static GalleryCustomColorTheme lerp(
      GalleryCustomColorTheme a, GalleryCustomColorTheme b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return GalleryCustomColorTheme(
      yellow: CustomColorTheme.lerp(a.yellow, b.yellow, t),
      pink: CustomColorTheme.lerp(a.pink, b.pink, t),
      blue: CustomColorTheme.lerp(a.blue, b.blue, t),
      darkBlue: CustomColorTheme.lerp(a.darkBlue, b.darkBlue, t),
      lime: CustomColorTheme.lerp(a.lime, b.lime, t),
      green: CustomColorTheme.lerp(a.green, b.green, t),
      red: CustomColorTheme.lerp(a.red, b.red, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CustomColorTheme>('yellow', yellow));
    properties.add(DiagnosticsProperty<CustomColorTheme>('pink', pink));
    properties.add(DiagnosticsProperty<CustomColorTheme>('blue', blue));
    properties.add(DiagnosticsProperty<CustomColorTheme>('darkBlue', darkBlue));
    properties.add(DiagnosticsProperty<CustomColorTheme>('lime', lime));
    properties.add(DiagnosticsProperty<CustomColorTheme>('green', green));
    properties.add(DiagnosticsProperty<CustomColorTheme>('red', red));
  }
}
