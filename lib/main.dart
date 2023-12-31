import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:we_do/data/firebase_wrapper.dart';
import 'package:we_do/firebase_options.dart';
import 'package:we_do/pages/home_page.dart';
import 'package:we_do/pages/onboard_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        switch (FirebaseWrapper.loggedIn.value) {
          case true:
            return const HomePage();
          case false:
          case null:
            // If we timeout (null), assume the user is not logged in.
            // TODO(adil192): Revisit this for offline support
            return const OnboardPage();
        }
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        // TODO(JoshChadwick): Make profile page
        return const Text('/profile not implemented yet');
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        // TODO(JoshChadwick): Make login page
        return const Text('/login not implemented yet');
      },
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseWrapper.init();

  // Wait for the user's login status to be determined, or timeout
  await FirebaseWrapper.loggedInFuture.timeout(
    const Duration(seconds: 1),
    onTimeout: () => false, // ignore timeout
  );

  runApp(const MyApp());
}

/// The root widget of the app.
class MyApp extends StatelessWidget {
  // ignore: public_member_api_docs
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
    );
  }
}
