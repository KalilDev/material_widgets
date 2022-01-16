import 'package:material_widgets/material_widgets.dart';

abstract class MD3SizeClassProperty<T> {
  const MD3SizeClassProperty();
  const factory MD3SizeClassProperty.all(T value) = _AllMD3SizeClassProperty<T>;
  static MD3SizeClassProperty<T?> only<T>({
    T? compact,
    T? medium,
    T? expanded,
  }) =>
      _OnlyMD3SizeClassProperty<T>(compact, medium, expanded);
  static MD3SizeClassProperty<T> fall<T>({
    required T compact,
    T? medium,
    T? expanded,
  }) =>
      _FallMD3SizeClassProperty<T>(compact, medium, expanded);
  const factory MD3SizeClassProperty.every({
    required T compact,
    required T medium,
    required T expanded,
  }) = _EveryMD3SizeClassProperty<T>;
  static MD3SizeClassProperty<T> resolveWith<T>(
          T Function(MD3WindowSizeClass) resolve) =>
      _ResolveWithMD3SizeClassProperty<T>(resolve);
  T resolve(MD3WindowSizeClass sizeClass);
}

class _AllMD3SizeClassProperty<T> extends MD3SizeClassProperty<T> {
  const _AllMD3SizeClassProperty(this.value);
  final T value;

  @override
  T resolve(MD3WindowSizeClass sizeClass) => value;
}

class _OnlyMD3SizeClassProperty<T> extends MD3SizeClassProperty<T?> {
  const _OnlyMD3SizeClassProperty(this.compact, this.medium, this.expanded);

  final T? compact;
  final T? medium;
  final T? expanded;

  @override
  T? resolve(MD3WindowSizeClass sizeClass) {
    switch (sizeClass) {
      case MD3WindowSizeClass.compact:
        return compact;
      case MD3WindowSizeClass.medium:
        return medium;
      case MD3WindowSizeClass.expanded:
        return expanded;
    }
  }
}

class _FallMD3SizeClassProperty<T> extends MD3SizeClassProperty<T> {
  const _FallMD3SizeClassProperty(this.compact, this.medium, this.expanded);

  final T compact;
  final T? medium;
  final T? expanded;

  @override
  T resolve(MD3WindowSizeClass sizeClass) {
    switch (sizeClass) {
      case MD3WindowSizeClass.compact:
        return compact;
      case MD3WindowSizeClass.medium:
        return medium ?? compact;
      case MD3WindowSizeClass.expanded:
        return expanded ?? medium ?? compact;
    }
  }
}

class _EveryMD3SizeClassProperty<T> extends MD3SizeClassProperty<T> {
  const _EveryMD3SizeClassProperty({
    required this.compact,
    required this.medium,
    required this.expanded,
  });

  final T compact;
  final T medium;
  final T expanded;

  @override
  T resolve(MD3WindowSizeClass sizeClass) {
    switch (sizeClass) {
      case MD3WindowSizeClass.compact:
        return compact;
      case MD3WindowSizeClass.medium:
        return medium;
      case MD3WindowSizeClass.expanded:
        return expanded;
    }
  }
}

class _ResolveWithMD3SizeClassProperty<T> extends MD3SizeClassProperty<T> {
  const _ResolveWithMD3SizeClassProperty(this._resolve);

  final T Function(MD3WindowSizeClass) _resolve;

  @override
  T resolve(MD3WindowSizeClass sizeClass) => _resolve(sizeClass);
}
