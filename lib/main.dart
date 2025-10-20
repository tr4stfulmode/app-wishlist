import 'package:app_wishlist/pages/LoginPage.dart';
import 'package:app_wishlist/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/LoginPage.dart';
import 'pages/wishlist_page.dart';
import 'pages/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wishlist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            return _getHomePageByEmail(user.email);
          }
          return const LoginPage();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _getHomePageByEmail(String? email) {
    // Определяем админов по email
    const adminEmails = [
      'tr4stfulmode@mail.ru'
    ];

    if (email != null && adminEmails.contains(email)) {
      return const WishlistPage();
    } else {
      return const WishlistPage();
    }
  }
}