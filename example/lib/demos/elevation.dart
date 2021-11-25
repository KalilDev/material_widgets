import 'package:example/common/layout.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';

class ElevationDemo extends StatelessWidget {
  const ElevationDemo({Key key}) : super(key: key);

  Widget _card(MD3ElevationLevel level, BuildContext context) => Center(
        child: Material(
          color: context.colorScheme.background,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Material(
                elevation: level.value,
                color: level.overlaidColor(
                  context.colorScheme.surface,
                  MD3ElevationLevel.surfaceTint(context.colorScheme),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final elevation = context.elevation;
    final title = context.textTheme.headlineSmall;

    return MD3AdaptativeScaffold(
      appBar: MD3CenterAlignedAppBar(
        title: Text('Elevation'),
      ),
      body: ListView(
        children: [
          margin,
          Text('Level 0', style: title),
          gutter,
          _card(elevation.level0, context),
          margin,
          Text('Level 1', style: title),
          gutter,
          _card(elevation.level1, context),
          margin,
          Text('Level 2', style: title),
          gutter,
          _card(elevation.level2, context),
          margin,
          Text('Level 3', style: title),
          gutter,
          _card(elevation.level3, context),
          margin,
          Text('Level 4', style: title),
          gutter,
          _card(elevation.level4, context),
          margin,
        ],
      ),
    );
  }
}
