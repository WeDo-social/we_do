import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:we_do/data/firebase_wrapper.dart';

/// A button that displays the user's profile picture,
/// or a random icon if the user is not logged in,
/// and opens the profile page when pressed.
class ProfileButton extends StatelessWidget {
  // ignore: public_member_api_docs
  const ProfileButton({super.key});

  /// A random "person" icon to use when the user is not logged in
  static final IconData _unknownUserIcon = switch (Random().nextInt(4)) {
    0 => Icons.person,
    1 => Icons.person_2,
    2 => Icons.person_3,
    3 => Icons.person_4,
    (int value) => () {
        if (kDebugMode) {
          throw Exception('Random number generator is broken, got $value');
        }
        return Icons.person;
      }(),
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FirebaseWrapper.user,
      builder: (context, user, _) {
        return IconButton(
          icon: user == null
              ? Icon(_unknownUserIcon)
              : Text(user.uid.substring(0, 1).toUpperCase()),
          onPressed: () {
            context.push('/profile');
          },
        );
      },
    );
  }
}
