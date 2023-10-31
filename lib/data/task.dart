import 'package:flutter/material.dart';

/// The data structure for a task
class Task with ChangeNotifier {
  // ignore: public_member_api_docs
  Task({
    required this.id,
    required String title,
    bool isDone = false,
  })  : _title = title,
        _isDone = isDone;

  /// Creates a task from a JSON map
  factory Task.fromJson(int id, Map<String, dynamic> json) {
    return Task(
      id: id,
      title: '',
    )..updateFromJson(json);
  }

  /// Updates the task from a JSON map
  void updateFromJson(Map<String, dynamic> json) {
    title = json['title'];
    isDone = json['isDone'];
  }

  /// The task's unique ID.
  /// This is used as the key in the database.
  final int id;

  String _title;

  /// The task's title
  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  bool _isDone;

  /// Whether the task is done
  bool get isDone => _isDone;
  set isDone(bool value) {
    _isDone = value;
    notifyListeners();
  }

  /// Serializes the task to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }
}
