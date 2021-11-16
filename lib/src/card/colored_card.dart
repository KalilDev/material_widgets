import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/src/card/card_style_card.dart';
import 'package:material_you/material_you.dart';

import 'filled_card.dart';

class ColoredCard extends FilledCard {
  const ColoredCard({
    Key key,
    @required this.color,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    FocusNode focusNode,
    CardStyle style,
    @required Widget child,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          focusNode: focusNode,
          style: style,
          child: child,
        );

  final CustomColorScheme color;

  static CardStyle styleFrom({
    Color backgroundColor,
    Color foregroundColor,
    MD3StateLayerOpacityTheme stateLayerOpacity,
  }) {
    if (stateLayerOpacity != null) {
      ArgumentError.checkNotNull(foregroundColor, 'foregroundColor');
    }
    return CardStyle(
      backgroundColor: ButtonStyleButton.allOrNull(backgroundColor),
      stateLayerColor: stateLayerOpacity == null
          ? null
          : MD3StateOverlayColor(
              foregroundColor,
              stateLayerOpacity,
            ),
      foregroundColor: ButtonStyleButton.allOrNull(foregroundColor),
    );
  }

  @override
  CardStyle defaultStyleOf(BuildContext context) {
    return super.defaultStyleOf(context).merge(
          styleFrom(
            backgroundColor: color.colorContainer,
            foregroundColor: color.onColorContainer,
            stateLayerOpacity: context.stateOverlayOpacity,
          ),
        );
  }
}
