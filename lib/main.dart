import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geocoding/geocoding.dart' as geo;
//screens
import 'firebase_options.dart';
import 'screens/animated_logo_loading_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  //
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  //   appleProvider: AppleProvider.appAttest,
  // );
  await geo.setLocaleIdentifier('en');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Help Loop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Use your custom fonts as the default
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontFamily: 'MigraExtraBold'),
          bodyLarge: TextStyle(fontFamily: 'MigraExtraLight'),
        ),
      ),
      // support for Arabic and system locale detection
      localeResolutionCallback: (locale, supportedLocales) => locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AnimatedLogoLoadingScreen(),

routes: {
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
 
},
    );
  }
}