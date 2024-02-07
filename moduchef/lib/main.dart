import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fridgeat/features/onboarding/loading_screen.dart';

import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:fridgeat/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

UserSelections userSelections = UserSelections();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(
    child: ModuChefApp(),
  ));
}

class ModuChefApp extends StatelessWidget {
  const ModuChefApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ModuChef',
      theme: ThemeData(
        textTheme: GoogleFonts.nanumGothicTextTheme(),
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xff232820),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}
