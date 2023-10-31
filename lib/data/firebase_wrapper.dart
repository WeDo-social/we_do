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
      loggedIn.value = uid.value != null;

      if (uid.value != null && !kIsWeb) {
        // Keep the user's data synced to the local cache
        FirebaseDatabase.instance.ref('users/${uid.value}').keepSynced(true);
      }

      if (_oldUid != null && !kIsWeb) {
        // Clear the old data
        FirebaseDatabase.instance.ref('users/$_oldUid').keepSynced(false);
      }
    });

  /// Whether the user is logged in.
  /// If null, the user's login status is unknown (still loading).
  static final ValueNotifier<bool?> loggedIn = ValueNotifier(null)
    ..addListener(() {
      if (loggedIn.value == null) return;
      if (_loggedInCompleter.isCompleted) return;
      _loggedInCompleter.complete(loggedIn.value);
    });

  /// A completer that completes when [loggedIn] is no longer null.
  /// This is used for [loggedInFuture].
  static final Completer<bool?> _loggedInCompleter = Completer<bool>();

  /// A future that completes when [loggedIn] is no longer null.
  static Future<bool?> get loggedInFuture => _loggedInCompleter.future;

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
      print('authStateChanges: $user');
      uid.value = user?.uid;
    });
  }

  /// Writes a task to the database.
  static Future writeTask(Task task) {
    if (uid.value == null) {
      throw Exception('Must be logged in to write a task');
    }
    final ref =
        FirebaseDatabase.instance.ref('users/${uid.value}/tasks/${task.id}');
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
