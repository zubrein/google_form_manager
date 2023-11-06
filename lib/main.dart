import 'package:flutter/material.dart';
import 'package:google_form_manager/core/helper/google_auth_helper.dart';

import 'auth/ui/login_page.dart';
import 'core/di/dependency_initializer.dart';
import 'core/helper/logger.dart';

void main() {
  configureDependencies();
  Log.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google form manager',
      home: LoginPage(),
    );
  }
}
