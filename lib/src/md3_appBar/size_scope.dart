import 'package:flutter/material.dart';

class Handle<T> {
  Handle(this._attach, this._detach);

  final void Function(T) _attach;
  final void Function(T) _detach;

  bool _disposed = false;
  void update(T? value) {
    if (_disposed) {
      throw StateError('Handle already disposed!');
    }
    if (_value != null && value != _value) {
      _detach(_value!);
    }
    _value = value;
    if (value != null) {
      _attach(value);
    }
  }

  @mustCallSuper
  void detach() {
    if (_disposed) {
      throw StateError('Handle already disposed!');
    }
    if (_value != null) {
      _detach(_value!);
    }
    _value = null;
  }

  @mustCallSuper
  void dispose() {
    detach();
    _disposed = true;
  }

  T? _value;
  T? get value => _value;
}

class MD3AppBarSizeInfo extends InheritedWidget {
  const MD3AppBarSizeInfo({
    Key? key,
    required this.size,
    required Widget child,
  }) : super(key: key, child: child);

  final Size? size;

  static MD3AppBarSizeInfo? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MD3AppBarSizeInfo>();

  @override
  bool updateShouldNotify(MD3AppBarSizeInfo oldWidget) =>
      size != oldWidget.size;
}

class MD3AppBarSizeScope extends StatefulWidget {
  const MD3AppBarSizeScope({
    Key? key,
    required this.initialSize,
    this.duration = const Duration(milliseconds: 200),
    required this.child,
  }) : super(key: key);
  final Size initialSize;
  final Duration duration;
  final Widget child;

  @override
  MD3AppBarSizeScopeState createState() => MD3AppBarSizeScopeState();
}

class MD3AppBarSizeScopeState extends State<MD3AppBarSizeScope>
    with SingleTickerProviderStateMixin {
  late Animation<Size?> _currentSize;
  late Animation<double> _curvedAnim;
  late AnimationController _animController;

  void initState() {
    super.initState();
    _currentSize = AlwaysStoppedAnimation(widget.initialSize);
    _animController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  static MD3AppBarSizeScopeState? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedMD3AppBarSizeScope>()
      ?.self;

  //
  // Debug information for notifying the user of [MD3AppBarSizeScope] when
  // multiple appbars are trying to update the size. Everyting is only checked
  // in debug mode, and the reference to the appbar (at _debugCurrentAppbar) is
  // only stored in debug, so that there isn't any chance of leaking it.
  //

  Object? _debugCurrentAppbar;
  bool _debugCheckIsCurrent(Object target) {
    return _debugCurrentAppbar == target;
  }

  bool _debugCheckNoCurrent() {
    return _debugCurrentAppbar == null;
  }

  bool _debugSetCurrent(Object? target) {
    _debugCurrentAppbar = target;
    return true;
  }

  void _setSize(Size target) {
    if (!_animController.isAnimating && _currentSize.value == target) {
      return;
    }
    // The widget may have been disposed after the previous frame
    if (!mounted) {
      return;
    }
    setState(() => _currentSize = AlwaysStoppedAnimation(target));
  }

  void _animateSizeTo(Size target) {
    if (!_animController.isAnimating && _currentSize.value == target) {
      return;
    }
    // The widget may have been disposed after the previous frame
    if (!mounted) {
      return;
    }
    setState(
      () => _currentSize = SizeTween(
        begin: _currentSize.value,
        end: target,
      ).animate(_curvedAnim),
    );
    _animController.forward(from: 0.0);
  }

  void registerAppBar(Object appbar, Size preferredSize) {
    assert(
      _debugCheckNoCurrent() || _debugCheckIsCurrent(appbar),
      'The MD3AppBarSizeScope expected that there wasn´t any registered '
      'appbars when registering $appbar, but $_debugCurrentAppbar is already '
      'registered. Check that only one MD3RawAppBar is primary inside this '
      'MD3AppBarSizeScope.',
    );
    assert(_debugSetCurrent(appbar));
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _animateSizeTo(preferredSize),
    );
  }

  void updateAppBarSize(Object appbar, Size preferredSize) {
    assert(
      _debugCheckIsCurrent(appbar),
      'The MD3AppBarSizeScope expected updates only from $_debugCurrentAppbar, '
      'but $appbar tried to update the size! Check that only one MD3RawAppBar '
      'is primary inside this MD3AppBarSizeScope.',
    );
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _setSize(preferredSize),
    );
  }

  void unregisterAppBar(Object appbar) {
    assert(
      _debugCheckIsCurrent(appbar),
      'The MD3AppBarSizeScope expected that $appbar was registered when '
      'unregistering it, but $_debugCurrentAppbar was registered instead! '
      'Check that only one MD3RawAppBar is primary inside this '
      'MD3AppBarSizeScope.',
    );
    assert(_debugSetCurrent(null));
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _animateSizeTo(widget.initialSize),
    );
  }

  void didUpdateWidget(MD3AppBarSizeScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animController.duration = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMD3AppBarSizeScope(
      self: this,
      child: ValueListenableBuilder<Size?>(
        valueListenable: _currentSize,
        builder: (context, size, _) => MD3AppBarSizeInfo(
          size: size,
          child: widget.child,
        ),
      ),
    );
  }
}

class _InheritedMD3AppBarSizeScope extends InheritedWidget {
  const _InheritedMD3AppBarSizeScope({
    Key? key,
    required this.self,
    required Widget child,
  }) : super(key: key, child: child);

  final MD3AppBarSizeScopeState self;

  @override
  bool updateShouldNotify(_InheritedMD3AppBarSizeScope oldWidget) =>
      oldWidget.self != self;
}
