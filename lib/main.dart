import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_form_manager/feature/form_list/ui/form_list_page.dart';
import 'core/di/dependency_initializer.dart';
import 'core/helper/logger.dart';
import 'feature/auth/ui/login_page.dart';

void main() {
  configureDependencies();
  Log.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google form manager',
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/formList': (context) => const FormListPage(),
      },
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
      home: const LoginPage(),
    );
  }
}
