import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:social_movie_app/models/ai_suggest.dart';
import 'package:social_movie_app/screens/account.dart';
import 'package:social_movie_app/screens/home.dart';
import 'package:social_movie_app/screens/watch_list_page.dart';
import 'package:social_movie_app/screens/my_profile.dart';
import 'package:social_movie_app/screens/preferences.dart';
import 'package:social_movie_app/screens/sign_in.dart';
import 'package:social_movie_app/screens/sign_up.dart';
import 'package:social_movie_app/screens/suprise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diji',
      theme: ThemeData(
          colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: AppColors.red,
              onPrimary: AppColors.white,
              secondary: AppColors.red,
              onSecondary: AppColors.white,
              error: AppColors.red,
              onError: AppColors.red,
              background: AppColors.white,
              onBackground: AppColors.white,
              surface: AppColors.dark,
              onSurface: AppColors.red)),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            return HomePage();
          } else {
            return HomePage();
          }
        }
      },
    );
  }
}
