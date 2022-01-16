import 'package:example/common/layout.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

class MenuDemo extends StatefulWidget {
  const MenuDemo({Key? key}) : super(key: key);

  @override
  _MenuDemoState createState() => _MenuDemoState();
}

RelativeRect rectFromContext(BuildContext context) {
  final button = context.findRenderObject()! as RenderBox;
  final overlay = Overlay.of(context)!.context.findRenderObject()! as RenderBox;
  return RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );
}

class _MenuDemoState extends State<MenuDemo> {
  TestEnum? value = null;
  bool enabled = true;

  void _setValue(TestEnum? v) {
    setState(() => value = v!);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Changed to $v')));
  }

  ValueChanged<TestEnum?>? get setValue => enabled ? _setValue : null;

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    final scheme = context.colorScheme;
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(
        title: Text('Popup Menu'),
        actions: [
          Builder(
            builder: (context) => MD3PopupMenuButton<void>(
              itemBuilder: (_) => [
                MD3PopupMenuItem(value: null, child: Text('Protetor de tela')),
                MD3PopupMenuItem(value: null, child: Text('Configurações')),
                MD3PopupMenuItem(value: null, child: Text('Enviar feedback')),
                MD3PopupMenuItem(value: null, child: Text('Ajuda')),
              ],
              child: Icon(Icons.more_vert),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          margin,
          Text('Menu normal', style: title),
          gutter,
          MD3PopupMenuButton<TestEnum>(
            itemBuilder: (context) => TestEnum.values
                .map((e) =>
                    MD3PopupMenuItem<TestEnum>(value: e, child: Text(e.name)))
                .toList(),
            onSelected: _setValue,
            initialValue: value,
            child: ListTile(title: Text('Abrir')),
          ),
          margin,
          Text('Menu normal com checkboxes', style: title),
          gutter,
          MD3PopupMenuButton<TestEnum>(
            itemBuilder: (context) => TestEnum.values
                .map((e) => MD3CheckedPopupMenuItem<TestEnum>(
                    value: e, child: Text(e.name)))
                .toList(),
            onSelected: _setValue,
            initialValue: value,
            child: ListTile(title: Text('Abrir')),
          ),
          margin,
          Text('Menu de seleção', style: title),
          gutter,
          MD3PopupMenuButton<TestEnum>(
            itemBuilder: (context) => TestEnum.values
                .map((e) => MD3SelectablePopupMenuItem<TestEnum>(
                    value: e, child: Text(e.text)))
                .toList(),
            onSelected: _setValue,
            initialValue: value,
            child: ListTile(title: Text('Abrir')),
            menuKind: MD3PopupMenuKind.selection,
          ),
          margin,
        ],
      ),
    );
  }
}

extension on TestEnum {
  String get text {
    switch (this) {
      case TestEnum.foo:
        return 'Ativam a soneca';
      case TestEnum.bar:
        return 'Parar';
      case TestEnum.foobar:
        return 'Controlam o volume';
    }
  }
}

enum TestEnum {
  foo,
  bar,
  foobar,
}
