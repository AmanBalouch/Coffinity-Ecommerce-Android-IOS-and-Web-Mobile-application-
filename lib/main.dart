import 'package:coffeemobileapplicationandroid/UX/Providers/DBProvider.dart';
import 'package:coffeemobileapplicationandroid/UX/Providers/authProvider.dart';
import 'package:coffeemobileapplicationandroid/UX/Providers/orderProvider.dart';
import 'package:coffeemobileapplicationandroid/screens/homeScreen.dart';
import 'package:coffeemobileapplicationandroid/screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/scalePageTransitionBuilder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDIVoOL8ReMjqC1NaGqz3YcoafDiEKaavk",
          authDomain: "coffee-android-application.firebaseapp.com",
          projectId: "coffee-android-application",
          storageBucket: "coffee-android-application.firebasestorage.app",
          messagingSenderId: "1085785604189",
          appId: "1:1085785604189:web:3750a5110f966e99a88db4",
          measurementId: "G-HZZ4SSBNBP"
      ),
    );
  } else {
    // Mobile initialization (uses native config files)
    await Firebase.initializeApp();
  }
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>authProvider()),
        ChangeNotifierProvider(create: (context)=>DBProvider()),
        ChangeNotifierProvider(create: (context)=>orderProvider())
      ],
      child: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _defaultScreen =splashScreen(); // default

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogined = prefs.getBool('login') ?? false;

    setState(() {
      _defaultScreen = isLogined ? homeScreen() : splashScreen();
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: scalePageTransitionBuilder(),
            TargetPlatform.iOS: scalePageTransitionBuilder(),
          },
        ),
      ),
      home: _defaultScreen,
    );
  }
}