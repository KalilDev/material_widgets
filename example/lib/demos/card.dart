import 'package:example/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

class CardsDemo extends StatefulWidget {
  const CardsDemo({
    Key? key,
  }) : super(key: key);

  @override
  State<CardsDemo> createState() => _CardsDemoState();
}

class _CardsDemoState extends State<CardsDemo> {
  bool _draggable = false;
  void _toggleDraggable() => setState(() => _draggable = !_draggable);

  Widget _buildCard(BuildContext context, int i) {
    void _onPressed() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pressed the card at $i'),
        ),
      );
    }

    final showLabel = i ~/ 4 < 1;
    switch (i % 4) {
      case 0:
        return OutlinedCard(
          child: Center(child: Text(showLabel ? 'Outlined' : '')),
          onPressed: _onPressed,
        );
      case 1:
        return FilledCard(
          child: Center(child: Text(showLabel ? 'Filled' : '')),
          onPressed: _onPressed,
        );
      case 2:
        return ElevatedCard(
          child: Center(child: Text(showLabel ? 'Elevated' : '')),
          onPressed: _onPressed,
        );
      case 3:
        final colorI = i ~/ 4;
        final namedColors = context.galleryColors.named;
        final color = namedColors[colorI % namedColors.length];
        return ColoredCard(
          child: Center(
            child: Text(
              colorI ~/ namedColors.length > 0 ? '' : color.name,
            ),
          ),
          onPressed: _onPressed,
          color: color.scheme ?? context.colorScheme.tertiaryScheme,
        );
    }
    throw StateError('Unreachable');
  }

  @override
  Widget build(BuildContext context) {
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(
        title: Text('Cards'),
      ),
      floatingActionButton: MD3FloatingActionButton.expanded(
        onPressed: _toggleDraggable,
        icon: Icon(Icons.drag_indicator),
        label: Text('Toggle draggable'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.sizeClass.columns ~/ 2,
          childAspectRatio: 1 / 1.3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (c, i) {
          final card = _buildCard(c, i);
          if (_draggable) {
            return DraggableCard(
              key: ObjectKey(i),
              child: card,
            );
          }
          return KeyedSubtree(
            key: ObjectKey(i),
            child: card,
          );
        },
      ),
    );
  }
}
