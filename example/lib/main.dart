import 'package:flutter/material.dart';

import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter_monet_theme/flutter_monet_theme.dart';

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
        themeMode: ThemeMode.dark,
        home: FluidGridMaterialLayout(
          child: Home(),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final endDrawer = Drawer(
      child: Center(
        child: Text("End drawer"),
      ),
    );
    final navSpec = NavigationSpec(
        selectedIndex: 1,
        showWithExtendedDrawer: true,
        fullHeightDrawer: true,
        items: List.generate(
          4,
          (index) => NavigationItem(
            icon: Icon(Icons.home),
            label: Text("Label$index"),
            labelText: "Label$index",
          ),
        ),
        navHeaderBuilder: (context) => NavigationDrawerHeader(
            title: Text("Navigation"), subtitle: Text('Drawer example')),
        onChanged: (_) => null);
    final snackbar = SnackBar(content: Text("Snackbar"));
    return ResponsiveScaffold(
      appBar: ResponsiveAppbar(
        title: Text("Example"),
        actions: [
          for (var i = 0; i < 25; i++)
            ResponsiveAppbarAction.create(
                icon: Icon(Icons.title),
                onPressed: () => null,
                tooltip: "$i",
                title: Text("$i")),
        ],
      ),
      navigationSpec: navSpec,
      endDrawer: endDrawer,
      floatingActionButton: null,
      body: FluidUntilMaterialLayout(
        debugEnableVisualization: false,
        lastFluidBreakpoint: MaterialBreakpoint.seven,
        allowedBreakpoints: MaterialBreakpoint.values.take(7).toList(),
        margin: 36,
        child: Whiteframe(
          child: Builder(
            builder: (BuildContext context) => Center(
                child: Text(MaterialLayout.of(context).breakpoint.toString())),
          ),
        ),
      ),
    );
  }
}
