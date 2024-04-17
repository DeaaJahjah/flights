import 'package:firebase_core/firebase_core.dart';
import 'package:flights/core/routes/routes.dart';
import 'package:flights/core/utils/shred_prefs.dart';
import 'package:flights/features/auth/providers/auth_state_provider.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/features/splash_screen/splash_screen.dart';
import 'package:flights/firebase_options.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPrefs.prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthSataProvider>(
          create: (_) => AuthSataProvider(),
        ),
        ChangeNotifierProvider<FlightsProvider>(
          create: (_) => FlightsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flight Booking UI Concept',
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale("ar", "AE"),
        ],
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        onGenerateRoute: onGenerateRoute,
        theme: myLightThemeData,
        home: const SplashScreen(),
        // home: const HomePage(),
      ),
    );
  }
}

ThemeData myLightThemeData = ThemeData(
  fontFamily: 'Cario',
  
  useMaterial3: true,
  // primaryColor: R.primaryColor,
  primaryColorLight: R.primaryColor,
  primaryColor: const Color(0xff415a5c),
  indicatorColor: const Color(0xffffcfa1),
  canvasColor: const Color(0xff9dafb1),
  // colorSchemeSeed: R.primaryColor,
  appBarTheme: AppBarTheme(
      color: R.tertiaryColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: R.primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      )),
  colorScheme: ColorScheme.dark(background: R.primaryColor),
);
