import 'package:flutter/material.dart';

import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter_monet_theme/flutter_monet_theme.dart';
import 'package:material_you/material_you.dart';

final List<MaterialBreakpoint> kBreakpoints = [
  MaterialBreakpoint.one,
  MaterialBreakpoint.three,
  MaterialBreakpoint.five,
  MaterialBreakpoint.six,
  MaterialBreakpoint.seven
];

void main() {
  runPlatformThemedApp(
    MyApp(),
    initialOrFallback: () => PlatformPalette.fallback(
      primaryColor: Color(
        0xDEADBEEF,
      ),
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
        builder: (context, home) => ThemeSwitcher(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          child: home,
        ),
        home: FluidGridMaterialLayout(
          child: Home(
            toggleDark: _toggleDark,
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final VoidCallback toggleDark;

  const Home({Key key, this.toggleDark}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDrawers = true;
  _toggle() => setState(() => _isDrawers = !_isDrawers);
  int _i = 1;

  void _onChanged(int i) => setState(() => _i = i);

  MD3NavigationSpec get navSpec => MD3NavigationSpec(
        selectedIndex: _i,
        items: List.generate(
          4,
          (index) => NavigationItem(
            icon: Icon(Icons.home),
            label: Text("Label$index"),
            labelText: "Label$index",
          ),
        ),
        onChanged: _onChanged,
      );
  Widget _body(BuildContext context) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.sizeClass.columns ~/ 2,
          childAspectRatio: 1 / 1.3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (c, i) {
          switch (i % 3) {
            case 0:
              return OutlinedCard(
                child: SizedBox.expand(),
                onPressed: () {},
              );
            case 1:
              return FilledCard(
                child: SizedBox.expand(),
                onPressed: () {},
              );
            case 2:
              return ElevatedCard(
                child: SizedBox.expand(),
                onPressed: () {},
              );
          }
        },
      );
  @override
  Widget build(BuildContext context) {
    final endDrawer = Drawer(
      child: Center(
        child: Text("End drawer"),
      ),
    );
    final snackbar = SnackBar(content: Text("Snackbar"));
    final body = FluidUntilMaterialLayout(
      debugEnableVisualization: false,
      lastFluidBreakpoint: MaterialBreakpoint.seven,
      allowedBreakpoints: MaterialBreakpoint.values.take(7).toList(),
      margin: 36,
      child: Whiteframe(
        child: Builder(
          builder: (BuildContext context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(MaterialLayout.of(context).breakpoint.toString()),
              Text(context.sizeClass.toString()),
              Text(context.deviceType.toString()),
            ],
          ),
        ),
      ),
    );
    final appBar = ResponsiveAppbar(
      title: Text("Example"),
      buildActions: (context) => [
        for (var i = 0; i < 25; i++)
          ResponsiveAppbarAction(
            icon: Icon(Icons.title),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'AlertDialog',
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'This is an alert dialog that was created at index $i',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Okay'),
                  )
                ],
              ),
            ),
            tooltip: "$i",
            title: Text("$i"),
          ),
      ],
    );
    return MD3NavigationScaffold(
      delegate: _isDrawers
          ? MD3DrawersNavigationDelegate(
              appBar: appBar,
              endModalDrawer: endDrawer,
              floatingActionButton: _buildFab(context, false, true),
            )
          : MD3BottomNavigationDelegate(
              appBar: appBar,
              endModalDrawer: endDrawer,
              navigationFabBuilder: (context, isExpanded) =>
                  _buildFab(context, isExpanded, false),
            ),
      spec: navSpec,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(child: _body(context)),
          Center(
            child: ElevatedButton(
              onPressed: _toggle,
              child: Text('Toggle delegate'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFab(
      BuildContext context, bool isExpanded, bool expandedOnMediumAndLarge) {
    if (context.sizeClass == MD3WindowSizeClass.compact) {
      return MD3FloatingActionButton.large(
        fabColorScheme: MD3FABColorScheme.tertiary,
        onPressed: widget.toggleDark,
        isLowered: true,
        child: Icon(Icons.color_lens),
      );
    }
    return MD3FloatingActionButton.expanded(
      fabColorScheme: MD3FABColorScheme.tertiary,
      onPressed: widget.toggleDark,
      isLowered: true,
      isExpanded: expandedOnMediumAndLarge || isExpanded,
      icon: Icon(Icons.color_lens),
      label: expandedOnMediumAndLarge
          ? Text('Change Theme')
          : Center(child: Text('Change Theme')),
    );
  }
}
