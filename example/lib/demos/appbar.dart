import 'package:example/common/custom_color.dart';
import 'package:example/common/layout.dart';
import 'package:example/demos/fab.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

class AppBarDemo extends StatefulWidget {
  const AppBarDemo({Key? key}) : super(key: key);

  @override
  State<AppBarDemo> createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<AppBarDemo>
    with SingleTickerProviderStateMixin {
  bool isElevated = false;
  void _toggleElevated() => setState(() => isElevated = !isElevated);

  bool _hasBottom = false;
  void _toggleBottom() => setState(() => _hasBottom = !_hasBottom);

  late final _tabController = TabController(vsync: this, length: 3);
  void initState() {
    super.initState();
    _tabController;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildBottom(BuildContext context) => MD3TabBar(
        tabs: [
          Tab(text: 'First tab'),
          Tab(text: 'Second tab'),
          Tab(text: 'Third tab'),
        ],
        controller: _tabController,
      );

  PreferredSizeWidget? get bottom => _hasBottom ? _buildBottom(context) : null;

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(
        title: Text('Top AppBar'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Tooltip(
            message: 'Toggle elevation',
            child: MD3FloatingActionButton.small(
              onPressed: _toggleElevated,
              fabColorScheme: MD3FABColorScheme.tertiary,
              child: Icon(Icons.low_priority),
            ),
          ),
          gutter,
          MD3FloatingActionButton.expanded(
            onPressed: _toggleBottom,
            label: Text('Toggle Bottom'),
            icon: Icon(Icons.border_bottom),
          ),
        ],
      ),
      body: ListView(
        children: [
          margin,
          Text('Centered', style: title),
          gutter,
          _AppBarWrapper(
            color: context.galleryColors.yellow,
            child: MD3CenterAlignedAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Title Large'),
              trailing: Icon(Icons.more_vert),
              bottom: bottom,
              isElevated: isElevated,
            ),
          ),
          margin,
          Text('Small', style: title),
          gutter,
          _AppBarWrapper(
            color: context.galleryColors.pink,
            child: MD3SmallAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Title Large'),
              actions: [
                Icon(Icons.attach_file),
                Icon(Icons.calendar_today),
                Icon(Icons.more_vert),
              ],
              bottom: bottom,
              isElevated: isElevated,
            ),
          ),
          margin,
          Text('Medium', style: title),
          gutter,
          _AppBarWrapper(
            color: context.galleryColors.blue,
            child: MD3MediumAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Headline Small'),
              actions: [
                Icon(Icons.attach_file),
                Icon(Icons.calendar_today),
                Icon(Icons.more_vert),
              ],
              bottom: bottom,
              isElevated: isElevated,
            ),
          ),
          margin,
          Text('Large', style: title),
          gutter,
          _AppBarWrapper(
            color: context.galleryColors.darkBlue,
            child: MD3LargeAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Headline Medium'),
              actions: [
                Icon(Icons.attach_file),
                Icon(Icons.calendar_today),
                Icon(Icons.more_vert),
              ],
              bottom: bottom,
              isElevated: isElevated,
            ),
          ),
          margin,
          Text('Responsive (small)', style: title),
          gutter,
          _AppBarWrapper(
            color: context.galleryColors.lime,
            child: ResponsiveAppbar.center(
              leading: Icon(null),
              primary: false,
              title: Text('Title Large'),
              buildActions: (_) => [
                MD3ResponsiveAppBarAction(
                  icon: Icon(Icons.attach_file),
                  tooltip: 'Anexar arquivo',
                  title: Text('Arquivo'),
                  onPressed: () {},
                ),
                MD3ResponsiveAppBarAction(
                  icon: Icon(Icons.calendar_today),
                  tooltip: 'Ir ao calendario',
                  title: Text('Calendario'),
                  onPressed: () {},
                ),
                MD3ResponsiveAppBarAction(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                  onPressed: () {},
                ),
                MD3ResponsiveAppBarAction(
                  title: Text('Send Feedback'),
                  onPressed: () {},
                ),
              ],
              bottom: bottom,
              isElevated: isElevated,
            ),
          ),
          margin,
        ],
      ),
    );
  }
}

class _AppBarWrapper extends StatelessWidget {
  const _AppBarWrapper({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);
  final CustomColorScheme color;
  final PreferredSizeWidget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      color: color.colorContainer,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: child.preferredSize.height),
          child: child,
        ),
      ),
    );
  }
}
