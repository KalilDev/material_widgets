import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_appBar/raw_appbar.dart';
import 'package:material_widgets/src/md3_scaffold/scaffold.dart';
import 'package:material_you/material_you.dart';

class MD3FullScreenDialog extends StatelessWidget {
  const MD3FullScreenDialog({
    Key? key,
    this.title,
    required this.action,
    required this.body,
  }) : super(key: key);

  final Widget? title;
  final Widget action;
  final Widget body;

  Widget _close(BuildContext context) => Tooltip(
        message: MaterialLocalizations.of(context).closeButtonLabel,
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      );
  Widget _title(BuildContext context) => DefaultTextStyle(
        style: context.textTheme.titleLarge.copyWith(
          color: context.colorScheme.onSurface,
        ),
        child: title!,
      );

  @override
  Widget build(BuildContext context) => MD3AdaptativeScaffold(
        appBar: MD3RawAppBar(
          appBarHeight: 56,
          leadingWidth: 64,
          leading: _close(context),
          titleSpacing: 0,
          title: title == null ? null : _title(context),
          actions: [
            action,
            const SizedBox(width: 24),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: body,
        ),
        bodyMargin: false,
      );
}
