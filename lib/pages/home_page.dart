import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:we_do/components/profile_button.dart';
import 'package:we_do/components/task_card.dart';
import 'package:we_do/data/task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('We Do'),
            actions: [
              ProfileButton(),
            ],
          ),
          SliverMasonryGrid.count(
            crossAxisCount: 3,
            childCount: 100,
            itemBuilder: (context, index) {
              return TaskCard(
                task: Task(
                  id: index,
                  title: 'Task $index',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
