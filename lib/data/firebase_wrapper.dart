import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:we_do/data/task.dart';

abstract class FirebaseWrapper {
  // TODO(adil192): Use actual auth uid
  static String uid = 'testuser';

  static void init() {
    // Persist data offline so the app works when offline
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    // Always keep this data synced to the local cache
    // even if it hasn't been used recently
    final ref = FirebaseDatabase.instance.ref("users/$uid");
    ref.keepSynced(true);
  }

  static Future writeTask(Task task) {
    final ref = FirebaseDatabase.instance.ref('users/$uid/tasks/${task.id}');
    return ref.set(task.toJson());
  }

  static StreamSubscription<DatabaseEvent> listenToTask(Task task) {
    final ref = FirebaseDatabase.instance.ref('users/$uid/tasks/${task.id}');
    return ref.onValue.listen((event) {
      final json = event.snapshot.value as Map<String, dynamic>?;
      if (json == null) return;
      task.updateFromJson(json);
    });
  }
}
