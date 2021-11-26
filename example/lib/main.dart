import 'package:example/card_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

import 'demos.dart';

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
  void _toggleDark() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MD3Themes(
      monetThemeForFallbackPalette: baseline_3p,
      builder: (context, lightTheme, darkTheme) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routes: Map.fromEntries(Demo.demos.map((e) => e.toRouteEntry())),
        builder: (context, home) {
          return ThemeSwitcher(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            child: home,
          );
        },
        home: Home(
          toggleDark: _toggleDark,
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key key,
    this.toggleDark,
  }) : super(key: key);
  final VoidCallback toggleDark;

  Widget _buildFab(BuildContext context) {
    if (context.sizeClass == MD3WindowSizeClass.compact) {
      return MD3FloatingActionButton.large(
        onPressed: toggleDark,
        isLowered: true,
        child: Icon(Icons.color_lens),
      );
    }
    return MD3FloatingActionButton.expanded(
      onPressed: toggleDark,
      isLowered: true,
      icon: Icon(Icons.color_lens),
      label: Text('Change Theme'),
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
          label: Text('Home'),
          icon: Icon(Icons.home),
          activeIcon: Icon(Icons.home),
        ),
        ...Demo.demos.map((e) => e.toNavigationItem())
      ],
      onChanged: navigate,
    );
    return MD3NavigationScaffold(
      spec: spec,
      delegate: MD3DrawersNavigationDelegate(
        appBar: MD3CenterAlignedAppBar(title: Text('MD3 Gallery')),
        floatingActionButton: _buildFab(context),
      ),
      bodyMargin: false,
      body: const _DemosGrid(),
    );
  }
}

class _DemosGrid extends StatelessWidget {
  const _DemosGrid({Key key}) : super(key: key);

  Widget _buildDemo(BuildContext context, int i) =>
      Demo.demos[i].buildCardSwitcher(context);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final parameters = gridParametersForMinWidth(
            constraints.maxWidth - 2 * context.minMargin,
            minWidth: 176,
          );
          return gridViewFromParameters(
            parameters,
            childDelegate: SliverChildBuilderDelegate(
              _buildDemo,
              childCount: Demo.demos.length,
            ),
            mainAxisExtent: parameters.itemWidth + Demo.kCardBottomHeight,
            padding: EdgeInsets.all(context.minMargin),
          );
        },
      );
}
