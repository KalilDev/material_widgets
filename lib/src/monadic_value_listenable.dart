import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension MonadicValueListenable<T> on ValueListenable<T>/*!*/ {
  ValueListenable<T1> map<T1>(T1 Function(T) fn) =>
      _MappedValueListenable(this, fn);
  ValueListenable<T1> bind<T1>(ValueListenable<T1> Function(T) fn) =>
      _BoundValueListenable(this, fn);
}

class _MappedValueListenable<T, T1> implements ValueListenable<T1> {
  final ValueListenable<T>/*!*/ _base;
  final T1 Function(T) _mapper;

  _MappedValueListenable(this._base, this._mapper);

  @override
  void addListener(VoidCallback listener) => _base.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => _base.removeListener(listener);

  @override
  T1 get value => _mapper(_base.value);
}

class _BoundValueListenable<T, T1> extends ChangeNotifier
    implements ValueListenable<T1> {
  final ValueListenable<T>/*!*/ _base;
  final ValueListenable<T1> Function(T) _mapper;

  _BoundValueListenable(this._base, this._mapper);

  void _onMapped() {
    notifyListeners();
  }

  void _onBase() {
    final newMapped = _mapper(_base.value);
    if (newMapped == _mapped) {
      return;
    }
    if (_mapped != null) {
      _mapped.removeListener(_onMapped);
    }
    _mapped = newMapped;
    newMapped.addListener(_onMapped);
    notifyListeners();
  }

  var _isBaseBeingListened = false;
  void _unlistenIfNeeded() {
    if (hasListeners || !_isBaseBeingListened) {
      return;
    }
    _base.removeListener(_onBase);
    _mapped?.removeListener(_onMapped);
    _mapped = null;
    _isBaseBeingListened = false;
  }

  void _listenIfNeeded() {
    if (_isBaseBeingListened) {
      return;
    }
    _base.addListener(_onBase);
    _isBaseBeingListened = true;
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _listenIfNeeded();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    _unlistenIfNeeded();
  }

  ValueListenable<T1> _mapped;

  @override
  T1 get value => _mapped?.value ?? _mapper(_base.value).value;
}

Widget runValueListenableWidget(ValueListenable<Widget> self) =>
    ValueListenableBuilder<Widget>(
      valueListenable: self,
      builder: (context, child, _) => child,
    );

Widget runValueListenableWidgetBuilder(
  ValueListenable<Widget Function(BuildContext, Widget)> self,
  Widget child,
) =>
    ValueListenableBuilder<Widget Function(BuildContext, Widget)>(
      valueListenable: self,
      builder: (context, childBuilder, child) => childBuilder(context, child),
      child: child,
    );
