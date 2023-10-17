import 'package:flutter/material.dart';

class Task with ChangeNotifier {
  Task({
    required this.id,
    required String title,
    bool isDone = false,
  })  : _title = title,
        _isDone = isDone;

  factory Task.fromJson(int id, Map<String, dynamic> json) {
    return Task(
      id: id,
      title: '',
    )..updateFromJson(json);
  }
  void updateFromJson(Map<String, dynamic> json) {
    title = json['title'];
    isDone = json['isDone'];
  }

  final int id;

  String _title;
  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  bool _isDone;
  bool get isDone => _isDone;
  set isDone(bool value) {
    _isDone = value;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }
}
