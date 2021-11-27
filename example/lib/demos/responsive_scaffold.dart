import 'package:example/common/layout.dart';
import 'package:flutter/material.dart';

import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

class ResponsiveScaffoldDemo extends StatefulWidget {
  const ResponsiveScaffoldDemo({Key? key}) : super(key: key);
  @override
  State<ResponsiveScaffoldDemo> createState() => _ResponsiveScaffoldDemoState();
}

class _ResponsiveScaffoldDemoState extends State<ResponsiveScaffoldDemo> {
  bool _isDrawers = true;
  int _i = 1;

  void _onChanged(int i) => setState(() => _i = i);
  void _toggleDelegate() => setState(() => _isDrawers = !_isDrawers);
  void _onFab() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pressed on the FAB'),
        ),
      );

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
    return MD3NavigationScaffold(
      delegate: _isDrawers
          ? MD3DrawersNavigationDelegate(
              endModalDrawer: endDrawer,
              floatingActionButton: _buildFab(context, false, true),
            )
          : MD3BottomNavigationDelegate(
              endModalDrawer: endDrawer,
              navigationFabBuilder: (context, isExpanded) =>
                  _buildFab(context, isExpanded, false),
            ),
      spec: navSpec,
      bodyMargin: false,
      body: CustomScrollView(
        slivers: [
          MD3SliverAppBar(
            title: Text('Responsive Scaffold'),
          ),
          SliverFillViewport(
            delegate: SliverChildListDelegate(
              [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Current delegate:\n'
                        '${_isDrawers ? 'MD3DrawersNavigationDelegate' : 'MD3BottomNavigationDelegate'}'),
                    gutter,
                    FilledButton(
                      onPressed: _toggleDelegate,
                      child: Text('Change Delegate'),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFab(
    BuildContext context,
    bool isExpanded,
    bool expandedOnMediumAndLarge,
  ) {
    if (context.sizeClass == MD3WindowSizeClass.compact) {
      return MD3FloatingActionButton.large(
        onPressed: _onFab,
        isLowered: true,
        child: Icon(Icons.color_lens),
      );
    }
    return MD3FloatingActionButton.expanded(
      onPressed: _onFab,
      isLowered: true,
      isExpanded: expandedOnMediumAndLarge || isExpanded,
      icon: Icon(Icons.color_lens),
      label: expandedOnMediumAndLarge
          ? Text('An FAB')
          : Center(child: Text('An FAB')),
    );
  }
}
