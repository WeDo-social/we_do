import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The onboarding page of the app,
/// shown when the user is not logged in.
class OnboardPage extends StatelessWidget {
  // ignore: public_member_api_docs
  const OnboardPage({
    super.key,
  });

  static Future<void> _continueAsGuest(BuildContext context) async {
    await FirebaseAuth.instance.signInAnonymously();
    if (!context.mounted) return;
    context.pushReplacement('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('We Do'),
      ),
      body: ListView(
        children: [
          Container(
            // TODO(JoshChadwick): replace with image
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to We Do',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'The app that helps you and your friends get things done',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Center(
            child: FilledButton(
              onPressed: null,
              child: Text('Login/Signup'),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: FilledButton(
              onPressed: () => _continueAsGuest(context),
              child: const Text('Continue as guest'),
            ),
          ),
        ],
      ),
    );
  }
}
