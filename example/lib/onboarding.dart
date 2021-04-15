import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple[200],
        ),
      ),
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple,
        ),
      ),
      themeMode: ThemeMode.light,
      home: Scaffold(
        body: Body(),
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

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MaterialOnboarding(
      button: ElevatedButton(
        child: Text('GET STARTED'),
        onPressed: () => Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Voila'),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(cs.surface),
          overlayColor: MaterialStateProperty.all(cs.onSurface.withAlpha(40)),
          foregroundColor: MaterialStateProperty.all(cs.primary),
        ),
      ),
      pages: pages,
    );
  }
}
