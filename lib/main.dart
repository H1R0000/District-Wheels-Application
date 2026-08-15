import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Added dotenv import

import '/ui/auth/login_screen.dart';
import '/ui/shared/role_selection_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables before initializing Supabase
  await dotenv.load(fileName: ".env");

  // Initialize Supabase using the secure keys
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: DistrictWheelsApp()));
}

class DistrictWheelsApp extends StatelessWidget {
  const DistrictWheelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandYellow = Color(0xFFFFD301);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'District Wheels',
      theme: ThemeData(
        primaryColor: brandYellow,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandYellow,
          primary: brandYellow,
          secondary: brandYellow,
        ),
      ),
      home: Supabase.instance.client.auth.currentUser == null
          ? LoginScreen()
          : RoleSelectionWrapper(),
    );
  }
}
