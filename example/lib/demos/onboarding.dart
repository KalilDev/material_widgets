import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

class OnboardingDemo extends StatelessWidget {
  const OnboardingDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MD3AdaptativeScaffold(
      bodyMargin: false,
      body: MaterialOnboarding(
        button: FilledButton(
          child: Text('Get started'),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Voila'),
              action: SnackBarAction(
                label: 'Exit',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        pages: pages,
      ),
    );
  }
}

final pages = [
  MaterialOnboardingPage(
    image: Image.asset(
      'assets/onboarding.1.png',
      fit: BoxFit.cover,
    ),
    text: 'Find experiments happening nearby.',
    title: 'Your lab, everywhere',
  ),
  MaterialOnboardingPage(
    image: Image.asset(
      'assets/onboarding.2.png',
      fit: BoxFit.cover,
    ),
    text: 'See the compounds that make up the\nobject right in front of you.',
  ),
  MaterialOnboardingPage(
    image: Image.asset(
      'assets/onboarding.3.png',
      fit: BoxFit.cover,
    ),
    text:
        'Sync your favorite hidrocarbons\nand see them on any of your devices.',
  )
];
