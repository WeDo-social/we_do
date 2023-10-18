import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:we_do/components/profile_button.dart';
import 'package:we_do/components/task_card.dart';
import 'package:we_do/data/task.dart';

/// The home page containing a list of tasks.
class HomePage extends StatelessWidget {
  // ignore: public_member_api_docs
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
