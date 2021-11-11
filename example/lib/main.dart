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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MD3Themes(
      monetThemeForFallbackPalette: baseline_3p,
      builder: (context, lightTheme, darkTheme) => MaterialApp(
        title: 'Flutter Demo',
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        home: FluidGridMaterialLayout(
          child: Home(),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
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
      actions: [
        for (var i = 0; i < 25; i++)
          ResponsiveAppbarAction.create(
              icon: Icon(Icons.title),
              onPressed: () => null,
              tooltip: "$i",
              title: Text("$i")),
      ],
    );
    final fab = MD3FloatingActionButton.expanded(
      fabColorScheme: MD3FABColorScheme.tertiary,
      onPressed: () => showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Hello'),
          content: Text('World'),
        ),
      ),
      isExpanded: true,
      label: Text('Home'),
      icon: Icon(Icons.home),
    );
    return MD3NavigationScaffold(
      delegate: _isDrawers
          ? MD3DrawersNavigationDelegate(
              appBar: appBar,
              endModalDrawer: endDrawer,
              floatingActionButton: fab,
            )
          : MD3BottomNavigationDelegate(
              appBar: appBar,
              endModalDrawer: endDrawer,
              floatingActionButton: fab,
            ),
      spec: navSpec,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(child: Placeholder()),
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
}
