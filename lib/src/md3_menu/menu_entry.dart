import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import 'popup_menu.dart';

abstract class MD3PopupMenuEntry<T> implements Widget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const MD3PopupMenuEntry();
  bool represents(T value);
}

/// A horizontal divider in a material design popup menu.
///
/// This widget adapts the [Divider] for use in popup menus.
///
/// See also:
///
///  * [PopupMenuItem], for the kinds of items that this widget divides.
///  * [showMenu], a method to dynamically show a popup menu at a given location.
///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
///    it is tapped.
class MD3PopupMenuDivider extends StatelessWidget
    implements MD3PopupMenuEntry<Never> {
  /// Creates a horizontal divider for a popup menu.
  ///
  /// By default, the divider has a height of 16 logical pixels.
  const MD3PopupMenuDivider({Key? key, this.height = _kMenuDividerHeight})
      : super(key: key);
  static const double _kMenuDividerHeight = 16.0;

  /// The height of the divider entry.
  ///
  /// Defaults to 16 pixels.
  final double height;

  Widget build(BuildContext context) => Divider(height: height);

  @override
  bool represents(Never value) => false;
}

/// An item in a material design popup menu.
///
/// To show a popup menu, use the [showMenu] function. To create a button that
/// shows a popup menu, consider using [PopupMenuButton].
///
/// To show a checkmark next to a popup menu item, consider using
/// [CheckedPopupMenuItem].
///
/// Typically the [child] of a [PopupMenuItem] is a [Text] widget. More
/// elaborate menus with icons can use a [ListTile]. By default, a
/// [PopupMenuItem] is [kMinInteractiveDimension] pixels high. If you use a widget
/// with a different height, it must be specified in the [height] property.
///
/// {@tool snippet}
///
/// Here, a [Text] widget is used with a popup menu item. The `WhyFarther` type
/// is an enum, not shown here.
///
/// ```dart
/// const PopupMenuItem<WhyFarther>(
///   value: WhyFarther.harder,
///   child: Text('Working a lot harder'),
/// )
/// ```
/// {@end-tool}
///
/// See the example at [PopupMenuButton] for how this example could be used in a
/// complete menu, and see the example at [CheckedPopupMenuItem] for one way to
/// keep the text of [PopupMenuItem]s that use [Text] widgets in their [child]
/// slot aligned with the text of [CheckedPopupMenuItem]s or of [PopupMenuItem]
/// that use a [ListTile] in their [child] slot.
///
/// See also:
///
///  * [PopupMenuDivider], which can be used to divide items from each other.
///  * [CheckedPopupMenuItem], a variant of [PopupMenuItem] with a checkmark.
///  * [showMenu], a method to dynamically show a popup menu at a given location.
///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
///    it is tapped.
class MD3PopupMenuItem<T> extends StatelessWidget
    implements MD3PopupMenuEntry<T> {
  /// Creates a horizontal divider for a popup menu.
  ///
  /// By default, the divider has a height of 16 logical pixels.
  const MD3PopupMenuItem({
    Key? key,
    this.height = kMinInteractiveDimension,
    required this.value,
    required this.child,
    this.trailing,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  /// The height of the menu item.
  ///
  /// Defaults to [kMinInteractiveDimension].
  final double height;

  final T value;

  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  static const double kSeparatorWidth = 8;
  // TODO: this or 18.0
  static const double kHorizontalPadding = 16;

  VoidCallback _onTap(BuildContext context) => () {
        onTap?.call();

        Navigator.pop<T>(context, value);
      };

  Widget build(BuildContext context) => MergeSemantics(
        child: Semantics(
          button: true,
          enabled: enabled,
          child: SizedBox(
            height: height,
            child: InkWell(
              onTap: enabled ? _onTap(context) : null,
              canRequestFocus: enabled,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: Row(
                  children: [
                    DefaultTextStyle.merge(
                      style: context.textTheme.titleMedium,
                      child: child,
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: kSeparatorWidth),
                      const Spacer(),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  bool represents(T value) => value == this.value;
}

/// An item in a material design popup menu.
///
/// To show a popup menu, use the [showMenu] function. To create a button that
/// shows a popup menu, consider using [PopupMenuButton].
///
/// To show a checkmark next to a popup menu item, consider using
/// [CheckedPopupMenuItem].
///
/// Typically the [child] of a [PopupMenuItem] is a [Text] widget. More
/// elaborate menus with icons can use a [ListTile]. By default, a
/// [PopupMenuItem] is [kMinInteractiveDimension] pixels high. If you use a widget
/// with a different height, it must be specified in the [height] property.
///
/// {@tool snippet}
///
/// Here, a [Text] widget is used with a popup menu item. The `WhyFarther` type
/// is an enum, not shown here.
///
/// ```dart
/// const PopupMenuItem<WhyFarther>(
///   value: WhyFarther.harder,
///   child: Text('Working a lot harder'),
/// )
/// ```
/// {@end-tool}
///
/// See the example at [PopupMenuButton] for how this example could be used in a
/// complete menu, and see the example at [CheckedPopupMenuItem] for one way to
/// keep the text of [PopupMenuItem]s that use [Text] widgets in their [child]
/// slot aligned with the text of [CheckedPopupMenuItem]s or of [PopupMenuItem]
/// that use a [ListTile] in their [child] slot.
///
/// See also:
///
///  * [PopupMenuDivider], which can be used to divide items from each other.
///  * [CheckedPopupMenuItem], a variant of [PopupMenuItem] with a checkmark.
///  * [showMenu], a method to dynamically show a popup menu at a given location.
///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
///    it is tapped.
class MD3SelectablePopupMenuItem<T> extends StatelessWidget
    implements MD3PopupMenuEntry<T> {
  const MD3SelectablePopupMenuItem({
    Key? key,
    required this.value,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.mouseCursor,
  }) : super(key: key);

  final T value;

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final MouseCursor? mouseCursor;

  static const double kHorizontalPadding = 24;

  VoidCallback _onTap(BuildContext context) => () {
        onTap?.call();

        Navigator.pop<T>(context, value);
      };

  MaterialStateProperty<Color> _backgroundColor(MonetColorScheme scheme) =>
      MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.disabled)) {
            return scheme.onSurfaceVariant.withOpacity(0.38);
          }
          return scheme.primary;
        }
        return Colors.transparent;
      });
  MaterialStateProperty<Color> _foregroundColor(MonetColorScheme scheme) =>
      MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          if (states.contains(MaterialState.disabled)) {
            return scheme.onSurfaceVariant.withOpacity(0.38);
          }
          return scheme.onPrimary;
        }
        return scheme.onSurface;
      });

  Widget build(BuildContext context) {
    final isSelected =
        value == InheritedMD3PopupMenuScope.of<T>(context).selectedItem;
    final states = {
      if (isSelected) MaterialState.selected,
      if (!enabled) MaterialState.disabled,
    };
    final scheme = context.colorScheme;
    final backgroundColor = _backgroundColor(scheme).resolve(states);
    final foregroundColor = _foregroundColor(scheme).resolve(states);
    final effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!enabled) MaterialState.disabled,
      },
    );

    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        child: SizedBox(
          height: kMinInteractiveDimension,
          child: Ink(
            color: backgroundColor,
            child: InkWell(
              onTap: enabled ? _onTap(context) : null,
              canRequestFocus: enabled,
              mouseCursor: effectiveMouseCursor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kHorizontalPadding,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle.merge(
                    style: context.textTheme.titleMedium.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w400,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool represents(T value) => value == this.value;
}

/// An item with a checkmark in a material design popup menu.
///
/// To show a popup menu, use the [showMenu] function. To create a button that
/// shows a popup menu, consider using [PopupMenuButton].
///
/// A [CheckedPopupMenuItem] is kMinInteractiveDimension pixels high, which
/// matches the default minimum height of a [PopupMenuItem]. The horizontal
/// layout uses [ListTile]; the checkmark is an [Icons.done] icon, shown in the
/// [ListTile.leading] position.
///
/// {@tool snippet}
///
/// Suppose a `Commands` enum exists that lists the possible commands from a
/// particular popup menu, including `Commands.heroAndScholar` and
/// `Commands.hurricaneCame`, and further suppose that there is a
/// `_heroAndScholar` member field which is a boolean. The example below shows a
/// menu with one menu item with a checkmark that can toggle the boolean, and
/// one menu item without a checkmark for selecting the second option. (It also
/// shows a divider placed between the two menu items.)
///
/// ```dart
/// PopupMenuButton<Commands>(
///   onSelected: (Commands result) {
///     switch (result) {
///       case Commands.heroAndScholar:
///         setState(() { _heroAndScholar = !_heroAndScholar; });
///         break;
///       case Commands.hurricaneCame:
///         // ...handle hurricane option
///         break;
///       // ...other items handled here
///     }
///   },
///   itemBuilder: (BuildContext context) => <MD3PopupMenuEntry<Commands>>[
///     CheckedPopupMenuItem<Commands>(
///       checked: _heroAndScholar,
///       value: Commands.heroAndScholar,
///       child: const Text('Hero and scholar'),
///     ),
///     const PopupMenuDivider(),
///     const PopupMenuItem<Commands>(
///       value: Commands.hurricaneCame,
///       child: ListTile(leading: Icon(null), title: Text('Bring hurricane')),
///     ),
///     // ...other items listed here
///   ],
/// )
/// ```
/// {@end-tool}
///
/// In particular, observe how the second menu item uses a [ListTile] with a
/// blank [Icon] in the [ListTile.leading] position to get the same alignment as
/// the item with the checkmark.
///
/// See also:
///
///  * [PopupMenuItem], a popup menu entry for picking a command (as opposed to
///    toggling a value).
///  * [PopupMenuDivider], a popup menu entry that is just a horizontal line.
///  * [showMenu], a method to dynamically show a popup menu at a given location.
///  * [PopupMenuButton], an [IconButton] that automatically shows a menu when
///    it is tapped.
class MD3CheckedPopupMenuItem<T> extends StatefulWidget
    implements MD3PopupMenuEntry<T> {
  /// Creates a popup menu item with a checkmark.
  ///
  /// By default, the menu item is [enabled] but unchecked. To mark the item as
  /// checked, set [checked] to true.
  ///
  /// The `checked` and `enabled` arguments must not be null.
  const MD3CheckedPopupMenuItem({
    Key? key,
    this.value,
    this.checked = true,
    this.enabled = true,
    this.padding,
    this.child,
  })  : assert(checked != null),
        super(
          key: key,
        );
  final T? value;
  final bool enabled;
  final EdgeInsets? padding;
  final Widget? child;

  /// Whether to display a checkmark next to the menu item when it is selected.
  ///
  /// Defaults to false.
  ///
  /// When true, an [Icons.done] checkmark is displayed.
  ///
  /// When this popup menu item is selected, the checkmark will fade in or out
  /// as appropriate to represent the implied new state.
  final bool checked;

  @override
  State<MD3CheckedPopupMenuItem<T>> createState() =>
      _MD3CheckedPopupMenuItemState<T>();

  @override
  bool represents(T value) => value == this.value;
}

class _MD3CheckedPopupMenuItemState<T> extends State<MD3CheckedPopupMenuItem<T>>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 150);
  late AnimationController _controller;
  Animation<double> get _opacity => _controller.view;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _fadeDuration, vsync: this)
      ..addListener(() => setState(() {/* animation changed */}));
  }

  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final checked = widget.checked &&
        InheritedMD3PopupMenuScope.of<T>(context).selectedItem == widget.value;
    final value = checked ? 1.0 : 0.0;
    if (_didInit) {
      _controller.animateTo(value);
    } else {
      _controller.value = value;
    }
    _didInit = true;
  }

  void _onTap() {
    // This fades the checkmark in or out when tapped.
    if (widget.checked)
      _controller.reverse();
    else
      _controller.forward();

    Navigator.of(context).pop<T>(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: widget.enabled,
      onTap: widget.enabled ? _onTap : null,
      leading: FadeTransition(
        opacity: _opacity,
        child: Icon(_controller.isDismissed ? null : Icons.done),
      ),
      title: widget.child,
    );
  }
}
