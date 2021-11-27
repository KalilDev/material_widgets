import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'text_aligner.dart';

class _OnboardingPageScope extends InheritedWidget {
  const _OnboardingPageScope({
    required this.isDesktop,
    required this.isPortrait,
    required Widget child,
  }) : super(child: child);
  final bool isPortrait;
  final bool isDesktop;

  @override
  bool updateShouldNotify(_OnboardingPageScope old) =>
      isPortrait != old.isPortrait || isDesktop != old.isDesktop;

  static _OnboardingPageScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_OnboardingPageScope>();
}

/// Implements the https://material.io/design/communication/onboarding.html spec
class MaterialOnboardingPage extends StatelessWidget {
  const MaterialOnboardingPage({
    Key? key,
    this.image,
    this.text,
    this.title,
  }) : super(key: key);
  final Widget? image;
  final String? text;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return _OnboardingPageContent(
      image: image,
      text: text!,
      title: title,
    );
  }
}

Size _buttonSize(BuildContext context) =>
    ElevatedButtonTheme.of(context).style?.minimumSize?.resolve({}) ??
    const Size(64, 36);

class _PageText extends StatelessWidget {
  const _PageText({
    Key? key,
    required this.text,
    this.title,
    this.textAlign,
  }) : super(key: key);
  final String text;
  final String? title;
  final TextAlign? textAlign;

  List<Widget> _bodyAndSpacer(BuildContext context) {
    final textBody = text.split('\n');
    final titleStyle = Theme.of(context).textTheme.headline6!;
    final cs = Theme.of(context).colorScheme;
    final bodyStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: 15.0,
          color: Color.alphaBlend(cs.surface.withOpacity(0.4), cs.onSurface),
        );
    final textHeight =
        56 + 32 + (titleStyle.fontSize! * (titleStyle.height ?? 1.0));
    return [
      if (kIsWeb)
        SizedBox(
          height: textHeight,
          child: Column(
            crossAxisAlignment: textAlign == TextAlign.left
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: titleStyle,
                  textAlign: textAlign,
                ),
              for (final line in textBody)
                Text(
                  line,
                  style: bodyStyle,
                  textAlign: textAlign,
                )
            ],
          ),
        )
      else
        SizedBox(
          height: textHeight,
          child: TextAligner(
            title: title,
            body: textBody,
            titleAlign: textAlign,
            bodyAlign: textAlign,
            titleStyle: titleStyle,
            bodyStyle: bodyStyle,
          ),
        ),
      SizedBox(
        height: 24.0 + _buttonSize(context).height,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: _OnboardingPageScope.of(context)!.isPortrait
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _bodyAndSpacer(context),
      );
}

class _OnboardingPageContent extends StatelessWidget {
  const _OnboardingPageContent({
    Key? key,
    this.image,
    required this.text,
    this.title,
  }) : super(key: key);
  final Widget? image;
  final String text;
  final String? title;

  Widget? get _image => image;

  @override
  Widget build(BuildContext context) {
    if (_OnboardingPageScope.of(context)!.isPortrait) {
      final padding = _OnboardingPageScope.of(context)!.isDesktop
          ? EdgeInsets.zero
          : const EdgeInsets.only(
              bottom: _PortraitOnboardingBody.bottomBarHeight,
            );
      return Padding(
        padding: padding,
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(child: _image!),
              _PageText(
                text: text,
                title: title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.expand(
      child: Row(
        children: [
          Expanded(
            child: _image!,
          ),
          Expanded(
            child: _PageText(
              text: text,
              title: title,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

typedef PageIndicatorBuilder = Widget Function(
  BuildContext context,
  PageController controller,
);

/// Implements the https://material.io/design/communication/onboarding.html spec
class MaterialOnboarding extends StatefulWidget {
  const MaterialOnboarding({
    Key? key,
    required this.button,
    this.indicatorBuilder,
    required this.pages,
    this.autoSwitchInterval = const Duration(seconds: 2),
    this.pageTransitionDuration = const Duration(milliseconds: 400),
    this.pageTransitionCurve = Curves.easeInOut,
    this.desktopBgColor,
  }) : super(key: key);
  final Widget button;
  final PageIndicatorBuilder? indicatorBuilder;
  final List<Widget> pages;
  final Duration autoSwitchInterval;
  final Duration pageTransitionDuration;
  final Curve pageTransitionCurve;
  final Color? desktopBgColor;

  @override
  _MaterialOnboardingState createState() => _MaterialOnboardingState();
}

class _MaterialOnboardingState extends State<MaterialOnboarding> {
  late PageController controller;
  int _currentPage = 0;
  Stream<void>? _timer;
  late StreamSubscription _timerSubs;

  void _pageListener() {
    if (!isDesktop) {
      return;
    }
    final next = controller.page!.round();
    if (next == _currentPage) {
      return;
    }
    setState(() => _currentPage = next);
  }

  void _onTimer(void _) {
    if (controller.page!.toInt() == widget.pages.length - 1) {
      controller.animateToPage(
        0,
        duration: widget.pageTransitionDuration,
        curve: widget.pageTransitionCurve,
      );
      return;
    }
    _nextPage();
  }

  void _createTimer() {
    _timer = Stream<void>.periodic(widget.autoSwitchInterval);
    _timerSubs = _timer!.listen(_onTimer);
  }

  Future<void> _destroyTimer() async {
    await _timerSubs.cancel();
    _timer = null;
  }

  Future<void> _recreateTimer(VoidCallback callback) async {
    callback();
    await _destroyTimer();
    _createTimer();
  }

  @override
  void initState() {
    controller = PageController();
    controller.addListener(_pageListener);
    _createTimer();
    super.initState();
  }

  @override
  void dispose() {
    _destroyTimer();
    super.dispose();
  }

  bool get isDesktop => context.deviceType == MD3DeviceType.desktop;

  bool get isPortrait =>
      isDesktop || MediaQuery.of(context).orientation == Orientation.portrait;

  Color _desktopBg(BuildContext context) {
    if (widget.desktopBgColor != null) {
      return widget.desktopBgColor!;
    }
    final cs = Theme.of(context).colorScheme;
    if (cs.brightness == Brightness.dark) {
      return cs.surface;
    }
    return Color.alphaBlend(cs.onSurface.withAlpha(30), cs.surface);
  }

  final List<int> _activePointers = <int>[];

  void _addPointer(PointerDownEvent e) {
    if (_activePointers.isEmpty) {
      _destroyTimer();
    }
    _activePointers.add(e.pointer);
  }

  void _removePointer(PointerEvent e) {
    final result = _activePointers.remove(e.pointer);
    if (!result) {
      return;
    }
    if (_activePointers.isEmpty) {
      _createTimer();
    }
  }

  Widget _pointerListener({Widget? child}) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _addPointer,
      onPointerUp: _removePointer,
      onPointerCancel: _removePointer,
      child: child,
    );
  }

  Widget _pageView(BuildContext context, {required List<Widget> pages}) =>
      _pointerListener(
        child: _OnboardingPageScope(
          isPortrait: isPortrait,
          isDesktop: isDesktop,
          child: PageView(
            controller: controller,
            children: pages,
          ),
        ),
      );

  Widget _getStartedButton(BuildContext context) {
    return widget.button;
  }

  Widget _pageIndicator(BuildContext context) {
    if (widget.indicatorBuilder != null) {
      return widget.indicatorBuilder!(context, controller);
    }
    final cs = Theme.of(context).colorScheme;
    final whiteish = cs.brightness == Brightness.dark
        ? Color.alphaBlend(Colors.black.withOpacity(0.2), Colors.white)
        : Colors.white;
    return SmoothPageIndicator(
      controller: controller,
      count: widget.pages.length,
      onDotClicked: (i) => controller.animateToPage(
        i,
        duration: widget.pageTransitionDuration,
        curve: widget.pageTransitionCurve,
      ),
      effect: WormEffect(
        dotHeight: 8.0,
        dotWidth: 8.0,
        activeDotColor: isDesktop ? whiteish : cs.primary,
        dotColor: Color.alphaBlend(
          (isDesktop ? cs.onSurface : cs.primary).withAlpha(90),
          cs.surface,
        ),
      ),
    );
  }

  void _nextPage() => controller.nextPage(
        duration: widget.pageTransitionDuration,
        curve: widget.pageTransitionCurve,
      );

  void _previousPage() => controller.previousPage(
        duration: widget.pageTransitionDuration,
        curve: widget.pageTransitionCurve,
      );

  Widget _pageButton(BuildContext context, {required bool previous}) {
    final icon = IconButton(
      icon: Icon(previous ? Icons.arrow_back : Icons.arrow_forward),
      onPressed: () => _recreateTimer(previous ? _previousPage : _nextPage),
      color: Theme.of(context).colorScheme.primary,
    );
    final isVisible =
        previous ? _currentPage != 0 : _currentPage != widget.pages.length - 1;
    final size = 48 + (Theme.of(context).visualDensity.horizontal * 4);
    return Material(
      elevation: isVisible ? 4.0 : 0,
      type: MaterialType.card,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: isVisible ? null : _desktopBg(context),
      child: isVisible ? icon : SizedBox(height: size, width: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Container(
        color: _desktopBg(context),
        constraints: const BoxConstraints.expand(),
        child: _DesktopOnboardingBody(
          pageView: _pageView(context, pages: widget.pages),
          getStartedButton: _getStartedButton(context),
          pageIndicator: _pageIndicator(context),
          previousPageButton: _pageButton(context, previous: true),
          nextPageButton: _pageButton(context, previous: false),
        ),
      );
    }
    if (isPortrait) {
      return _PortraitOnboardingBody(
        pageView: _pageView(context, pages: widget.pages),
        getStartedButton: _getStartedButton(context),
        pageIndicator: _pageIndicator(context),
      );
    }
    return _LandscapeOnboardingBody(
      pageView: _pageView(context, pages: widget.pages),
      getStartedButton: _getStartedButton(context),
      pageIndicator: _pageIndicator(context),
    );
  }
}

class _LandscapeOnboardingBody extends StatelessWidget {
  const _LandscapeOnboardingBody({
    Key? key,
    required this.pageView,
    required this.getStartedButton,
    required this.pageIndicator,
  }) : super(key: key);
  final Widget pageView;
  final Widget getStartedButton;
  final Widget pageIndicator;

  static const double bottomBarHeight = 48.0;

  Widget _wrappedIndicator(BuildContext context) => SizedBox(
        height: bottomBarHeight,
        child: pageIndicator,
      );

  Widget _buttonAndIndicator(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: make this layout better, instead of using this magic number
            const SizedBox(height: 148),
            getStartedButton,
            const SizedBox(height: 24.0),
            _wrappedIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _pageViewWrapper(BuildContext context, {required Widget child}) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        child,
        _buttonAndIndicator(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pageViewWrapper(
      context,
      child: pageView,
    );
  }
}

class _PortraitOnboardingBody extends StatelessWidget {
  const _PortraitOnboardingBody({
    Key? key,
    required this.pageView,
    required this.getStartedButton,
    required this.pageIndicator,
  }) : super(key: key);
  final Widget pageView;
  final Widget getStartedButton;
  final Widget pageIndicator;

  static const double bottomBarHeight = 48.0;

  Widget _wrappedIndicator(BuildContext context) => SizedBox(
        height: bottomBarHeight,
        child: Center(
          child: pageIndicator,
        ),
      );

  Widget _pageViewWrapper(BuildContext context, {required Widget child}) {
    final positionedButton = Positioned(
      bottom: 24 + bottomBarHeight,
      child: getStartedButton,
    );
    final positionedIndicator = Positioned(
      bottom: 0,
      child: _wrappedIndicator(context),
    );
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        child,
        positionedButton,
        positionedIndicator,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pageViewWrapper(
      context,
      child: pageView,
    );
  }
}

class _DesktopOnboardingBody extends StatelessWidget {
  const _DesktopOnboardingBody({
    Key? key,
    required this.pageView,
    required this.getStartedButton,
    required this.pageIndicator,
    required this.previousPageButton,
    required this.nextPageButton,
  }) : super(key: key);
  final Widget pageView;
  final Widget getStartedButton;
  final Widget pageIndicator;
  final Widget previousPageButton;
  final Widget nextPageButton;

  Widget _desktopCard(BuildContext context, {Widget? child}) => ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 390 * 1.5,
          maxHeight: 430 * 1.5,
        ),
        child: AspectRatio(
          aspectRatio: 39 / 43,
          child: Card(child: child),
        ),
      );

  Widget _pageViewWrapper(BuildContext context, {required Widget child}) {
    final positionedButton = Positioned(
      bottom: 24,
      child: getStartedButton,
    );
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        child,
        positionedButton,
      ],
    );
  }

  Widget _pageIndicatorWrapper(BuildContext context, {required Widget child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: child),
        const SizedBox(
          height: 24,
        ),
        pageIndicator,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48.0,
              child: previousPageButton,
            ),
            const SizedBox(
              width: 24.0,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _pageIndicatorWrapper(
                  context,
                  child: _desktopCard(
                    context,
                    child: _pageViewWrapper(
                      context,
                      child: pageView,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 24.0,
            ),
            SizedBox(
              width: 48.0,
              child: nextPageButton,
            ),
          ],
        ),
      ),
    );
  }
}
