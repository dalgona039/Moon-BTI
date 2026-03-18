import 'package:flutter/material.dart';
import 'theme/app_tokens.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MoonBtiApp());
}

class MoonBtiApp extends StatelessWidget {
  const MoonBtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '문BTI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: kBg,
        textTheme: const TextTheme(
          // 7-step scale — 실제 위젯에서 Theme.of(context).textTheme.xxx 로 참조
          displayLarge: TextStyle(fontSize: kFontDisplay, fontWeight: FontWeight.w900, color: kAccent, height: 1.2, letterSpacing: 0.5),
          headlineMedium: TextStyle(fontSize: kFontHeadline, fontWeight: FontWeight.w700, color: kText, height: 1.25, letterSpacing: -0.5),
          titleLarge: TextStyle(fontSize: kFontTitle, fontWeight: FontWeight.w600, color: kSubText, height: 1.3, letterSpacing: 0.2),
          bodyLarge: TextStyle(fontSize: kFontBodyL, fontWeight: FontWeight.w500, color: kText, height: 1.6),
          bodyMedium: TextStyle(fontSize: kFontBody, fontWeight: FontWeight.w400, color: kText, height: 1.6, letterSpacing: 0.1),
          bodySmall: TextStyle(fontSize: kFontCaption, fontWeight: FontWeight.w400, color: kSubText, height: 1.5, letterSpacing: 0.2),
          labelLarge: TextStyle(fontSize: kFontCaption, fontWeight: FontWeight.w700, color: kAccent, height: 1.3, letterSpacing: 0.3),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
      },
    );
  }
}
