import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:financemanager/helpers/database_helper.dart';
import 'package:financemanager/pages/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.database;

  if (await authenticateUser()) {
    runApp(const MyApp());
  } else {
    runApp(const AuthenticationFailedApp());
  }
}

Future<bool> authenticateUser() async {
  final LocalAuthentication auth = LocalAuthentication();
  try {
    return await auth.authenticate(
      localizedReason: 'Please authenticate to access the app',
      options: const AuthenticationOptions(biometricOnly: true),
    );
  } catch (e) {
    print("Authentication error: $e");
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(16, 19, 37, 1),
        hintColor: Colors.tealAccent[400],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent[400],
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(16, 19, 37, 1)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(16, 19, 37, 1),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, color: Colors.white),
          titleMedium: TextStyle(fontSize: 20, color: Colors.white70),
          labelLarge: TextStyle(fontSize: 18, color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(16, 19, 37, 1),
          background: const Color.fromRGBO(16, 19, 37, 1),
        ),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

class AuthenticationFailedApp extends StatelessWidget {
  const AuthenticationFailedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Authentication failed. Please close and reopen the app to try again.'),
        ),
      ),
    );
  }
}
