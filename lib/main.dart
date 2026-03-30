import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/ui/auth/login_screen.dart';
import '/ui/shared/role_selection_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fhdxqdmmziatpojsuwnf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZoZHhxZG1temlhdHBvanN1d25mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQwNzI0NzAsImV4cCI6MjA4OTY0ODQ3MH0.OF8FSf-ZpBDajCqSOCDm6srn893qQBSEl-xQbf25lzM',
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
