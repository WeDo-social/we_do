import 'package:flutter/material.dart';
import 'package:we_do/data/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
  });

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
