import 'dart:math';

import 'package:example/common/layout.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

class ChipsDemo extends StatefulWidget {
  const ChipsDemo({
    Key? key,
  }) : super(key: key);

  @override
  State<ChipsDemo> createState() => _ChipsDemoState();
}

class _ChipsDemoState extends State<ChipsDemo> {
  bool _enabled = true;
  void _toggleEnabled() => setState(() => _enabled = !_enabled);

  VoidCallback? get _onChip => _enabled ? () {} : null;

  ChipRow _filter() => ChipRow(
        children: [
          MD3FilterChip(
            onPressed: _onChip,
            label: Text('Normal'),
          ),
          MD3FilterChip(
            onPressed: _onChip,
            label: Text('Elevated'),
            elevated: true,
          ),
          MD3FilterChip(
            onPressed: _onChip,
            label: Text('Normal (selected)'),
            selected: true,
          ),
          MD3FilterChip(
            onPressed: _onChip,
            label: Text('Elevated (selected)'),
            elevated: true,
            selected: true,
          ),
        ],
      );

  ChipRow _suggestion() => ChipRow(
        children: [
          MD3SuggestionChip(
            onPressed: _onChip,
            label: Text('Normal'),
          ),
          MD3SuggestionChip(
            onPressed: _onChip,
            label: Text('Elevated'),
            elevated: true,
          ),
          MD3SuggestionChip(
            onPressed: _onChip,
            label: Text('Normal (selected)'),
            selected: true,
          ),
          MD3SuggestionChip(
            onPressed: _onChip,
            label: Text('Elevated (selected)'),
            elevated: true,
            selected: true,
          ),
        ],
      );

  ChipRow _assist() => ChipRow(
        children: [
          MD3AssistChip(
            onPressed: _onChip,
            leading: Icon(Icons.home),
            label: Text('Normal'),
          ),
          MD3AssistChip(
            onPressed: _onChip,
            label: Text('Elevated'),
            leading: Icon(Icons.home),
            elevated: true,
          ),
        ],
      );

  ChipRow _input() => ChipRow(
        children: [
          MD3InputChip(
            onPressed: _onChip,
            label: Text('Normal'),
          ),
          MD3InputChip(
            onPressed: _onChip,
            label: Text('Normal (selected)'),
            leading: Icon(Icons.check),
            selected: true,
          ),
          MD3InputChip(
            onPressed: _onChip,
            label: Text('Normal (removable)'),
            trailing: Icon(Icons.close),
          ),
          MD3InputChip(
            onPressed: _onChip,
            label: Text('Normal (removable) (selected)'),
            leading: Icon(Icons.check),
            trailing: Icon(Icons.close),
            selected: true,
          ),
          MD3InputChip(
            onPressed: _onChip,
            label: Text('Avatar'),
            leading: Icon(Icons.account_circle, size: 24),
            leadingAvatar: true,
          ),
          MD3InputChip(
            onPressed: _onChip,
            label: Text('Avatar (selected)'),
            leading: Icon(Icons.account_circle, size: 24),
            leadingAvatar: true,
            selected: true,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;

    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(
        title: Text('Chips'),
      ),
      floatingActionButton: MD3FloatingActionButton.expanded(
        onPressed: _toggleEnabled,
        icon: Icon(Icons.label_off),
        label: Text('Toggle enabled'),
      ),
      body: ListView(
        children: [
          margin,
          Text('Filter', style: title),
          gutter,
          _filter(),
          margin,
          Text('Suggestion', style: title),
          gutter,
          _suggestion(),
          margin,
          Text('Assist', style: title),
          gutter,
          _assist(),
          margin,
          Text('Input', style: title),
          gutter,
          _input(),
          margin,
        ],
      ),
    );
  }
}

class ChipRow extends StatelessWidget {
  const ChipRow({
    Key? key,
    this.children,
  }) : super(key: key);

  final List<Widget>? children;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: min(500, MediaQuery.of(context).size.width * 2 / 3)),
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: ChipStyle.paddingBetweenElements,
            runSpacing: ChipStyle.paddingBetweenElements,
            children: children!,
          ),
        ),
      );
}
