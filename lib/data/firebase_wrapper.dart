import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:we_do/data/task.dart';

/// A wrapper around Firebase that handles authentication and data storage.
abstract class FirebaseWrapper {
  static String? _oldUid;
  /// The currently logged in user's uid, or null if no user is logged in.
  static final ValueNotifier<String?> uid = ValueNotifier(null)
    ..addListener(() {
      if (uid.value != null) {
        // Keep the user's data synced to the local cache
        FirebaseDatabase.instance
            .ref('users/${uid.value}')
            .keepSynced(true);
      }

      if (_oldUid != null) {
        // Clear the old data
        FirebaseDatabase.instance
            .ref('users/$_oldUid')
            .keepSynced(false);
      }
    });

  /// Initializes the Firebase wrapper.
  static void init() {
    if (!kIsWeb) {
      // Persist data offline so the app works when offline
      FirebaseDatabase.instance.setPersistenceEnabled(true);
      FirebaseDatabase.instance.setPersistenceCacheSizeBytes(
        // 100 MB
        100 * 1024 * 1024,
      );
    }

    FirebaseAuth.instance.authStateChanges().listen((user) {
      uid.value = user?.uid;
    });
  }

  /// Writes a task to the database.
  static Future writeTask(Task task) {
    if (uid.value == null) {
      throw Exception('Must be logged in to write a task');
    }
    final ref = FirebaseDatabase.instance.ref('users/${uid.value}/tasks/${task.id}');
    return ref.set(task.toJson());
  }

  /// Listens to changes to a task.
  static StreamSubscription<DatabaseEvent> listenToTask(
    Task task,
    String? uid,
  ) {
    uid ??= FirebaseWrapper.uid.value;
    if (uid == null) {
      throw Exception('uid is not specified, and no user is logged in');
    }

    final ref = FirebaseDatabase.instance.ref('users/$uid/tasks/${task.id}');
    return ref.onValue.listen((event) {
      final json = event.snapshot.value as Map<String, dynamic>?;
      if (json == null) return;
      task.updateFromJson(json);
    });
  }
}
