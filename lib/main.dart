import 'package:flutter/material.dart';
import 'package:progress_app/screens/auth/login.dart';
import 'package:progress_app/screens/dashboard/dashboard_screen.dart';
import 'package:progress_app/screens/profile/profile_screen.dart';
import 'package:progress_app/screens/projects/create.dart';
import 'package:progress_app/screens/projects/detail.dart';
import 'package:progress_app/screens/projects/projects_list.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: kPrimaryColor,
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CheckAuth(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashBoardScreen(),
        '/projects': (context) => const ProjectsScreen(),
        '/projects/create': (context) => const CreateProjectScreen(),
        '/projects/detail': (context) => const ProjectDetail(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn().then((value) => {
      if (value == null) {
        Navigator.pushReplacementNamed(context, '/login')
      } else {
        Navigator.pushReplacementNamed(context, '/dashboard')
      }
    });
  }

  Future<String?> _checkIfLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
