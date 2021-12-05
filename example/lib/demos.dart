import 'package:material_widgets/material_widgets.dart';

import 'demos/appbar.dart';
import 'demos/button.dart';
import 'demos/card.dart';
import 'demos/chip.dart';
import 'demos/dialog.dart';
import 'demos/elevation.dart';
import 'demos/fab.dart';
import 'demos/responsive_scaffold.dart';
import 'demos/slider.dart';
import 'demos/sliver_appbar.dart';
import 'demos/switch.dart';
import 'demos/theme.dart';
import 'demos/typography.dart';
import 'demos/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'widgets/card.dart';

class Demo {
  final String routeName;
  final WidgetBuilder builder;
  final String label;
  final Widget? icon;
  final Widget? image;
  final String? subtitle;
  final String? description;
  final String? specUrl;

  const Demo({
    required this.routeName,
    required this.builder,
    required this.label,
    this.icon,
    this.image,
    this.subtitle,
    this.description,
    this.specUrl,
  });

  MapEntry<String, WidgetBuilder> toRouteEntry() =>
      MapEntry('/$routeName', builder);
  NavigationItem toNavigationItem() => NavigationItem(
        labelText: label,
        icon: icon ?? Icon(null),
      );

  void navigate(BuildContext context) =>
      Navigator.of(context).pushNamed('/$routeName');

  static const double kCardBottomHeight = 40.0 + 16.0 + 16.0;
  void launchSpec() => launch(specUrl ?? 'https://m3.material.io/');

  Widget buildCardSwitcher(BuildContext context) => FlippableCard(
        bottomHeight: kCardBottomHeight,
        front: (context, flip) => ImageCard(
          bottom: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(child: Text(label)),
                FilledButton(
                  onPressed: flip,
                  child: Text('More'),
                )
              ],
            ),
          ),
          image: image ?? Image.asset('assets/image_placeholder.png'),
          onPressed: () => navigate(context),
        ),
        back: (context, flip) => TextCard(
          title: Text(label),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          content: description != null ? Text(description!) : SizedBox(),
          bottom: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              if (specUrl != null)
                TextButton(
                  onPressed: launchSpec,
                  child: Text('Spec'),
                ),
              SizedBox(width: 8),
              FilledTonalButton(
                onPressed: flip,
                child: Text('Less'),
              ),
            ],
          ),
          onPressed: () => navigate(context),
        ),
      );

  static final List<Demo> demos = [
    Demo(
      routeName: '/appbar',
      builder: (_) => AppBarDemo(),
      label: 'Top AppBar',
      description: 'Top app bars display information and actions at the top of '
          'a screen.',
      specUrl: 'https://m3.material.io/components/top-app-bar',
      image: Image.asset(
        'assets/appbar.png',
        cacheWidth: 312,
      ),
    ),
    Demo(
      routeName: '/button',
      builder: (_) => ButtonDemo(),
      label: 'Common Buttons',
      description: 'Buttons help people initiate actions, from sending an '
          'email, to sharing a document, to liking a post.',
      specUrl: 'https://m3.material.io/components/buttons',
      image: Image.asset(
        'assets/common_buttons.png',
        cacheWidth: 312,
      ),
    ),
    Demo(
      routeName: '/card',
      builder: (_) => CardsDemo(),
      label: 'Cards',
      description: 'Cards contain content and actions that relate '
          'information about a subject.',
      specUrl: 'https://m3.material.io/components/cards',
      image: Image.asset(
        'assets/cards.png',
        cacheWidth: 312,
      ),
    ),
    Demo(
      routeName: '/chip',
      builder: (_) => ChipsDemo(),
      label: 'Chips',
      description: 'Chips help people enter information, make selections, '
          'filter content, or trigger actions. Chips can use multiple '
          'interactive elements in the same area, such as a list or menu.',
      specUrl: 'https://m3.material.io/components/chips',
      image: Image.asset(
        'assets/chips.png',
        cacheWidth: 312,
      ),
    ),
    Demo(
      routeName: '/dialog',
      builder: (_) => DialogDemo(),
      label: 'Dialogs',
      description: 'Dialogs provide important prompts in a user flow. They can '
          'require an action, communicate information, or help users '
          'accomplish a task.',
      specUrl: 'https://m3.material.io/components/dialogs',
      image: Image.asset(
        'assets/dialogs.png',
        cacheWidth: 312,
      ),
    ),
    Demo(
      routeName: '/elevation',
      builder: (_) => ElevationDemo(),
      label: 'Elevation',
      description: 'Surfaces at elevation levels +1 to +5 are tinted via color '
          'overlays based on the primary color, such as app bars or menus. The '
          'addition of a grade from +1 to +5 introduces tonal variation to the '
          'surface baseline.',
      specUrl:
          'https://m3.material.io/styles/color/the-color-system/color-roles',
    ),
    Demo(
      routeName: '/fab',
      builder: (_) => FABDemo(),
      label: 'Floating action buttons (FAB)',
      description: 'The FAB represents the most important action on a screen. '
          'It puts key actions within reach.',
      specUrl: 'https://m3.material.io/components/floating-action-button',
      image: Image.asset(
        'assets/fab.png',
        cacheWidth: 312,
      ),
    ),
    Demo(
      routeName: '/onboarding',
      builder: (_) => OnboardingDemo(),
      label: 'Onboarding',
      description: 'Onboarding is a virtual unboxing experience that helps '
          'users get started with an app.',
      specUrl: 'https://material.io/design/communication/onboarding.html',
    ),
    Demo(
      routeName: '/responsive_scaffold',
      builder: (_) => ResponsiveScaffoldDemo(),
      label: 'Responsive Scaffold',
      description: 'Adaptive layouts react to input from users, devices, and '
          'screen elements. Material guidance describes how to design for '
          'variable screen sizes, from phones and tablets, to desktop and '
          'beyond.',
      specUrl: 'https://m3.material.io/foundations/adaptive-design',
    ),
    Demo(
      routeName: '/slider',
      builder: (_) => SliderDemo(),
      label: 'Slider',
      description:
          'Sliders allow users to make selections from a range of values.',
      specUrl: 'https://material.io/components/sliders',
    ),
    Demo(
      routeName: '/sliver_app_bar',
      builder: (_) => SliverAppBarDemo(),
      label: 'Sliver AppBar',
      description: 'Top app bars display information and actions at the top of '
          'a screen.',
      specUrl: 'https://m3.material.io/components/top-app-bar',
      image: Image.asset(
        'assets/appbar.png',
        cacheWidth: 312,
      ),
    ),
    Demo(
      routeName: '/switch',
      builder: (_) => SwitchDemo(),
      label: 'Switch',
      description: 'Switches toggle the state of a single item on or off.',
      specUrl: 'https://material.io/components/switches',
    ),
    Demo(
      routeName: '/theme',
      builder: (_) => ThemeDemo(),
      label: 'Color System',
      description: 'The color system handles the variability of dynamically '
          'changing color schemes that arise as user inputs change. The logic '
          'of tonal relationships and shifts in hue and chroma provide a '
          'foundation for flexible color application. Color schemes can be '
          'considered a cohesive group of relative tones, rather than a fixed '
          'group of constant values.',
      specUrl: 'https://m3.material.io/styles/color/the-color-system',
    ),
    Demo(
      routeName: 'typography',
      builder: (_) => TypographyDemo(),
      label: 'Typography',
      description: "Material's default type scale includes a range of "
          'contrasting and extensible styles to support a wide range of use '
          'cases.',
      specUrl: 'https://m3.material.io/styles/typography',
      image: Image.asset(
        'assets/typography.png',
        cacheWidth: 312,
      ),
    ),
  ];
}
