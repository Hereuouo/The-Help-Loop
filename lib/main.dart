import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';
//screens
import 'firebase_options.dart';
import 'screens/animated_logo_loading_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/skill_list_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/tracking_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'generated/l10n.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  if(!kIsWeb){
    await geo.setLocaleIdentifier('en');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'The Help Loop',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,

              textTheme: TextTheme(
                headlineLarge: TextStyle(fontFamily: 'MigraExtraBold'),
                bodyLarge: TextStyle(fontFamily: 'MigraExtraLight'),
              ),
            ),
            supportedLocales: LocaleProvider.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const AnimatedLogoLoadingScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/skills': (context) => const SkillListScreen(),
              '/tracking': (context) => const TrackingScreen(),
            },
          );
        },
      ),
    );
  }
}