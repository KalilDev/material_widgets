import 'package:example/card_grid.dart';
import 'package:example/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'demos.dart';

class RainbowSeedBuilder extends StatefulWidget {
  const RainbowSeedBuilder({
    Key? key,
    this.degreesPerSecond = 60,
    this.chroma = 48,
    this.tone = 40,
    this.isEnabled = true,
    required this.builder,
  }) : super(key: key);
  final double degreesPerSecond;
  final double chroma;
  final double tone;
  final bool isEnabled;
  final Widget Function(BuildContext context, Color) builder;

  @override
  _RainbowSeedBuilderState createState() => _RainbowSeedBuilderState();
}

class _RainbowSeedBuilderState extends State<RainbowSeedBuilder>
    with SingleTickerProviderStateMixin {
  late Stream<int> stream;

  double get degreesPerTick =>
      widget.degreesPerSecond /
      (Duration(seconds: 1).inMilliseconds /
          kThemeChangeDuration.inMilliseconds);

  void initState() {
    super.initState();
    _setStream();
  }

  void _setStream() {
    stream = widget.isEnabled
        ? Stream.periodic(kThemeAnimationDuration, (i) => i + 1)
        : Stream.empty();
  }

  @override
  void didUpdateWidget(RainbowSeedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnabled != widget.isEnabled) {
      _setStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: stream,
      initialData: 0,
      builder: (context, snapshot) {
        final hct = HctColor.from(
          degreesPerTick * snapshot.data!,
          widget.chroma,
          widget.tone,
        );
        final color = Color(hct.toInt());
        return widget.builder(context, color);
      },
    );
  }
}

void main() {
  runPlatformThemedApp(
    SystemEdgeToEdge(child: MyApp()),
    initialOrFallback: () => PlatformPalette.fallback(
      primaryColor: Color(0xDEADBEEF),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;
  bool _isRainbow = false;
  void _toggleDark() => setState(() => _isDark = !_isDark);
  void _toggleRainbow() => setState(() => _isRainbow = !_isRainbow);

  @override
  Widget build(BuildContext context) {
    final home = Home(
      toggleDark: _toggleDark,
      toggleRainbow: _toggleRainbow,
    );
    final themeMode = _isDark ? ThemeMode.dark : ThemeMode.light;
    return RainbowSeedBuilder(
      isEnabled: _isRainbow,
      builder: (context, rainbowSeed) =>
          MD3ThemedApp<GalleryCustomColorScheme, GalleryCustomColorTheme>(
        seed: _isRainbow ? rainbowSeed : null,
        monetThemeForFallbackPalette: _isRainbow ? null : baseline_3p,
        appThemeFactory: GalleryCustomColorTheme.harmonized,
        builder: (context, lightTheme, darkTheme) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          routes: Map.fromEntries(Demo.demos.map((e) => e.toRouteEntry())),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          builder: (context, home) => AnimatedMonetColorSchemes<
              GalleryCustomColorScheme, GalleryCustomColorTheme>(
            themeMode: themeMode,
            child: home!,
          ),
          home: home,
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.toggleDark,
    required this.toggleRainbow,
  }) : super(key: key);
  final VoidCallback toggleDark;
  final VoidCallback toggleRainbow;

  Widget _buildFab(BuildContext context) {
    if (context.sizeClass == MD3WindowSizeClass.compact) {
      return MD3FloatingActionButton.large(
        onPressed: toggleDark,
        isLowered: true,
        child: Icon(Icons.invert_colors),
      );
    }
    return MD3FloatingActionButton.expanded(
      onPressed: toggleDark,
      isLowered: true,
      icon: Icon(Icons.invert_colors),
      label: Text('Toggle Dark Theme'),
    );
  }

  @override
  Widget build(BuildContext context) {
    void navigate(int i) {
      if (i == 0) {
        return;
      }
      Demo.demos[i - 1].navigate(context);
    }

    final spec = MD3NavigationSpec(
      selectedIndex: 0,
      items: [
        NavigationItem(
          labelText: 'Home',
          icon: Icon(Icons.home),
        ),
        ...Demo.demos.map((e) => e.toNavigationItem())
      ],
      onChanged: navigate,
    );
    return MD3NavigationScaffold(
      spec: spec,
      delegate: MD3DrawersNavigationDelegate(
        appBar: MD3CenterAlignedAppBar(
          title: Text('MD3 Gallery'),
          trailing: Tooltip(
            message: 'Toggle Rainbow',
            child: IconButton(
              onPressed: toggleRainbow,
              icon: Icon(Icons.color_lens),
            ),
          ),
        ),
        floatingActionButton: _buildFab(context),
      ),
      body: MD3ScaffoldBody.noMargin(child: const _DemosGrid()),
    );
  }
}

class _DemosGrid extends StatelessWidget {
  const _DemosGrid({Key? key}) : super(key: key);

  Widget _buildDemo(BuildContext context, int i) =>
      Demo.demos[i].buildCardSwitcher(context);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final margin = InheritedMD3BodyMargin.of(context).margin;
          final parameters = gridParametersForMinWidth(
            constraints.maxWidth - 2 * margin,
            minWidth: 176,
          );
          return gridViewFromParameters(
            parameters,
            childDelegate: SliverChildBuilderDelegate(
              _buildDemo,
              childCount: Demo.demos.length,
            ),
            mainAxisExtent: parameters.itemWidth + Demo.kCardBottomHeight,
            padding: EdgeInsets.symmetric(
              horizontal: margin,
              vertical: context.sizeClass.minimumMargins,
            ),
          );
        },
      );
}
