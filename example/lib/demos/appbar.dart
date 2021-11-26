import 'package:example/common/layout.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

class AppBarDemo extends StatelessWidget {
  const AppBarDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(
        title: Text('Top AppBar'),
      ),
      body: ListView(
        children: [
          margin,
          Text('Centered', style: title),
          gutter,
          _AppBarWrapper(
            child: MD3CenterAlignedAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Title Large'),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          margin,
          Text('Small', style: title),
          gutter,
          _AppBarWrapper(
            child: MD3SmallAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Title Large'),
              actions: [
                Icon(Icons.attach_file),
                Icon(Icons.calendar_today),
                Icon(Icons.more_vert),
              ],
            ),
          ),
          margin,
          Text('Medium', style: title),
          gutter,
          _AppBarWrapper(
            child: MD3MediumAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Headline Small'),
              actions: [
                Icon(Icons.attach_file),
                Icon(Icons.calendar_today),
                Icon(Icons.more_vert),
              ],
            ),
          ),
          margin,
          Text('Large', style: title),
          gutter,
          _AppBarWrapper(
            child: MD3LargeAppBar(
              leading: Icon(null),
              primary: false,
              title: Text('Headline Medium'),
              actions: [
                Icon(Icons.attach_file),
                Icon(Icons.calendar_today),
                Icon(Icons.more_vert),
              ],
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
    Key key,
    @required this.child,
  }) : super(key: key);
  final PreferredSizeWidget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      color: context.colorScheme.background,
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
