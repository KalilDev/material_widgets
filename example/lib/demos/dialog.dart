import 'package:example/common/layout.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';

class DialogDemo extends StatelessWidget {
  const DialogDemo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;

    void time() {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }

    void basic() {
      showDialog(
        context: context,
        builder: (context) => MD3BasicDialog(
          title: Text('Basic Dialog'),
          content: Text('An basic dialog'),
        ),
      );
    }

    void basicIcon() {
      showDialog(
        context: context,
        builder: (context) => MD3BasicDialog(
          title: Text('Basic Dialog'),
          icon: Icon(Icons.home),
          content: Text('An basic dialog with an icon'),
        ),
      );
    }

    void fullScreen() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MD3FullScreenDialog(
            action: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Action'),
            ),
            title: Text('Title Large'),
            body: Center(
              child: Text('The body'),
            ),
          ),
        ),
      );
    }

    return MD3AdaptativeScaffold(
      appBar: MD3CenterAlignedAppBar(
        title: Text('Dialog'),
      ),
      body: ListView(
        children: [
          margin,
          Text('Time picker', style: title),
          gutter,
          FilledButton(onPressed: time, child: Text('Show')),
          margin,
          Text('Basic dialog', style: title),
          gutter,
          FilledButton(onPressed: basic, child: Text('Show')),
          margin,
          Text('Basic dialog (With icon)', style: title),
          gutter,
          FilledButton(onPressed: basicIcon, child: Text('Show')),
          margin,
          Text('Full screen dialog', style: title),
          gutter,
          FilledButton(onPressed: fullScreen, child: Text('Show')),
          margin,
        ],
      ),
    );
  }
}
