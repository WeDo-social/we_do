import 'package:flutter/material.dart';
import 'package:we_do/data/task.dart';

/// A card that displays a [Task].
class TaskCard extends StatelessWidget {
  // ignore: public_member_api_docs
  const TaskCard({
    super.key,
    required this.task,
  });

  /// The task to display
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedBuilder(
        animation: task,
        builder: (context, _) {
          return Column(
            children: [
              Checkbox.adaptive(
                value: task.isDone,
                onChanged: (value) {
                  task.isDone = value!;
                },
              ),
              Text(task.title),
            ],
          );
        }
      ),
    );
  }
}
