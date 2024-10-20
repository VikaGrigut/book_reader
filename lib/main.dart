import 'package:book_reader/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:book_reader/pages/MainPage.dart';

import 'i18n/strings.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MediaQuery.of(context).platformBrightness == Brightness.dark ? darkTheme : lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
      },
    );
  }
}

