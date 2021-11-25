import 'package:example/demos/appbar.dart';
import 'package:example/demos/button.dart';
import 'package:example/demos/card.dart';
import 'package:example/demos/chip.dart';
import 'package:example/demos/dialog.dart';
import 'package:example/demos/elevation.dart';
import 'package:example/demos/fab.dart';
import 'package:example/demos/responsive_scaffold.dart';
import 'package:example/demos/sliver_appbar.dart';
import 'package:example/demos/theme.dart';
import 'package:example/demos/typography.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

import 'demos/onboarding.dart';

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
        routes: {
          '/appbar': (_) => AppBarDemo(),
          '/button': (_) => ButtonDemo(),
          '/card': (_) => CardsDemo(),
          '/chip': (_) => ChipsDemo(),
          '/dialog': (_) => DialogDemo(),
          '/elevation': (_) => ElevationDemo(),
          '/fab': (_) => FABDemo(),
          '/onboarding': (_) => OnboardingDemo(),
          '/responsive_scaffold': (_) => ResponsiveScaffoldDemo(),
          '/sliver_app_bar': (_) => SliverAppBarDemo(),
          '/theme': (_) => ThemeDemo(),
          '/typography': (_) => TypographyDemo(),
        },
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

  static const kRoutes = [
    'appbar',
    'button',
    'card',
    'chip',
    'dialog',
    'elevation',
    'fab',
    'onboarding',
    'responsive_scaffold',
    'sliver_app_bar',
    'theme',
    'typography',
  ];

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
      Navigator.of(context).pushNamed('/${kRoutes[i - 1]}');
    }

    final spec = MD3NavigationSpec(
      selectedIndex: 0,
      items: [
        NavigationItem(
          label: Text('Home'),
          icon: Icon(Icons.home),
          activeIcon: Icon(Icons.home),
        ),
        NavigationItem(
          label: Text('AppBar'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Button'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Card'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Chip'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Dialog'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Elevation'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('FAB'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Onboarding'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Responsive Scaffold'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Sliver AppBar'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Theme'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
        NavigationItem(
          label: Text('Typography'),
          icon: Icon(null),
          activeIcon: Icon(null),
        ),
      ],
      onChanged: navigate,
    );
    return MD3NavigationScaffold(
      spec: spec,
      delegate: MD3DrawersNavigationDelegate(
        appBar: MD3CenterAlignedAppBar(title: Text('MD3 Gallery')),
        floatingActionButton: _buildFab(context),
      ),
      body: Text('Hello world'),
    );
  }
}
