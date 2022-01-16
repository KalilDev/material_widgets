import 'package:example/common/custom_color.dart';
import 'package:example/common/layout.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

enum FabType {
  expandedHidden,
  expandedShown,
  expandedLabel,
  large,
  small,
  regular,
}

enum FABColorScheme {
  primary,
  surface,
  secondary,
  tertiary,
  custom,
}

extension on FABColorScheme {
  // ignore: missing_return
  MD3FABColorScheme toMD3() {
    switch (this) {
      case FABColorScheme.primary:
        return MD3FABColorScheme.primary;
      case FABColorScheme.surface:
        return MD3FABColorScheme.surface;
      case FABColorScheme.secondary:
        return MD3FABColorScheme.secondary;
      case FABColorScheme.tertiary:
        return MD3FABColorScheme.tertiary;
      case FABColorScheme.custom:
        // ignored
        return MD3FABColorScheme.primary;
    }
  }
}

class FABSpec {
  final FabType fabType;
  final bool isLowered;
  final FABColorScheme colorScheme;
  final CustomColorScheme? customColor;

  FABSpec(
    this.fabType,
    this.isLowered,
    this.colorScheme,
    this.customColor,
  );
}

List<FABSpec> fabSpecPermutationsForType(FabType type, bool isLowered,
        [CustomColorScheme? customColor]) =>
    FABColorScheme.values
        .where((e) => customColor != null || e != FABColorScheme.custom)
        .map(
          (colorScheme) => FABSpec(
            type,
            isLowered,
            colorScheme,
            colorScheme == FABColorScheme.custom ? customColor : null,
          ),
        )
        .toList();

String fabPermutationName(FABSpec spec) {
  var name = '';
  switch (spec.fabType) {
    case FabType.expandedHidden:
      name += 'Expanded (Hidden)';
      break;
    case FabType.expandedShown:
      name += 'Expanded (Shown)';
      break;
    case FabType.expandedLabel:
      name += 'Expanded (No icon)';
      break;
    case FabType.large:
      name += 'Large';
      break;
    case FabType.small:
      name += 'Small';
      break;
    case FabType.regular:
      name += 'Regular';
      break;
  }
  name += ' - ';
  switch (spec.colorScheme) {
    case FABColorScheme.primary:
      name += 'Primary Container';
      break;
    case FABColorScheme.surface:
      name += 'Surface';
      break;
    case FABColorScheme.secondary:
      name += 'Secondary';
      break;
    case FABColorScheme.tertiary:
      name += 'Tertiary';
      break;
    case FABColorScheme.custom:
      name += 'Custom';
  }
  if (spec.isLowered) {
    name += ' - Lowered';
  }
  return name;
}

// ignore: missing_return
Widget buildFabPermutation(FABSpec spec, VoidCallback onPressed) {
  switch (spec.fabType) {
    case FabType.expandedHidden:
    case FabType.expandedShown:
    case FabType.expandedLabel:
      return MD3FloatingActionButton.expanded(
        onPressed: onPressed,
        icon: spec.fabType == FabType.expandedLabel ? null : Icon(Icons.edit),
        label: Text('Edit'),
        isExpanded: spec.fabType != FabType.expandedHidden,
        fabColorScheme: spec.colorScheme.toMD3(),
        isLowered: spec.isLowered,
        colorScheme: spec.customColor,
      );
    case FabType.large:
      return MD3FloatingActionButton.large(
        onPressed: onPressed,
        child: Icon(Icons.edit),
        fabColorScheme: spec.colorScheme.toMD3(),
        isLowered: spec.isLowered,
        colorScheme: spec.customColor,
      );
    case FabType.small:
      return MD3FloatingActionButton.small(
        onPressed: onPressed,
        child: Icon(Icons.edit),
        fabColorScheme: spec.colorScheme.toMD3(),
        isLowered: spec.isLowered,
        colorScheme: spec.customColor,
      );
    case FabType.regular:
      return MD3FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.edit),
        fabColorScheme: spec.colorScheme.toMD3(),
        isLowered: spec.isLowered,
        colorScheme: spec.customColor,
      );
  }
}

class FABDemo extends StatefulWidget {
  const FABDemo({
    Key? key,
  }) : super(key: key);

  @override
  State<FABDemo> createState() => _FABDemoState();
}

class _FABDemoState extends State<FABDemo> {
  CustomColorScheme? customColor;
  int _customColorI = 0;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCustomColor();
  }

  void _toggleCustomColor() => setState(() {
        ++_customColorI;
        _updateCustomColor();
      });

  void _updateCustomColor() {
    final colors = context.galleryColors.named;
    customColor = colors[_customColorI % colors.length].scheme;
  }

  bool _lowered = false;
  void _toggleLowered() => setState(() => _lowered = !_lowered);

  void onFab(FABSpec fab) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pressed ${fabPermutationName(fab)}',
          ),
        ),
      );

  Widget _row(List<FABSpec> specs) => Wrap(
        spacing: gutter.width!,
        runSpacing: gutter.height!,
        children:
            specs.map((e) => buildFabPermutation(e, () => onFab(e))).toList(),
      );

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(
        title: Text('Floating action buttons (FAB)'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Tooltip(
            message: 'Toggle lowered',
            child: MD3FloatingActionButton.small(
              onPressed: _toggleLowered,
              child: Icon(Icons.low_priority),
              fabColorScheme: MD3FABColorScheme.primary,
            ),
          ),
          gutter,
          MD3FloatingActionButton.expanded(
            onPressed: _toggleCustomColor,
            icon: Icon(Icons.color_lens),
            label: Text('Change color'),
            fabColorScheme: MD3FABColorScheme.surface,
          ),
        ],
      ),
      body: MD3ScaffoldBody.noMargin(
        child: Builder(
            builder: (context) => ListView(
                  padding: InheritedMD3BodyMargin.of(context).padding,
                  children: [
                    margin,
                    Text('Regular', style: title),
                    gutter,
                    _row(fabSpecPermutationsForType(
                        FabType.regular, _lowered, customColor)),
                    margin,
                    Text('Large', style: title),
                    gutter,
                    _row(fabSpecPermutationsForType(
                        FabType.large, _lowered, customColor)),
                    margin,
                    Text('Small', style: title),
                    gutter,
                    _row(fabSpecPermutationsForType(
                        FabType.small, _lowered, customColor)),
                    margin,
                    Text('Expanded', style: title),
                    gutter,
                    _row(fabSpecPermutationsForType(
                        FabType.expandedShown, _lowered, customColor)),
                    margin,
                    Text('Expanded (label only)', style: title),
                    gutter,
                    _row(fabSpecPermutationsForType(
                        FabType.expandedLabel, _lowered, customColor)),
                    margin,
                    Text('Expanded (hidden)', style: title),
                    gutter,
                    _row(fabSpecPermutationsForType(
                        FabType.expandedHidden, _lowered, customColor)),
                    margin,
                  ],
                )),
      ),
    );
  }
}
