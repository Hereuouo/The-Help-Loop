import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

//screens
import 'screens/animated_logo_loading_screen.dart';
import 'screens/Welcome_screen.dart';
import 'screens/auth_wrapper.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/EmailVerificationScreen.dart'; 
import 'screens/skill_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/font_styles.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCDMxQM7HtYnztO4qWsoVH_hMehvWSV5fU",
        authDomain: "the-help-loop.firebaseapp.com",
        projectId: "the-help-loop",
        storageBucket: "the-help-loop.firebasestorage.app",
        messagingSenderId: "846984349819",
        appId: "1:846984349819:web:984c384731b73b1f4efade",
        measurementId: "G-L9FDXW6MQR",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
      home: const AnimatedLogoLoadingScreen(), // the loading screen initially

routes: {
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/skills': (context) => const SkillListScreen(),
  '/booking': (context) => const BookingScreen(),
  '/tracking': (context) => const TrackingScreen(),
},
    );
  }
}