import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_do/components/task_card.dart';
import 'package:we_do/data/task.dart';

void main() {
  testWidgets('TaskCard', (tester) async {
    final task = Task(id: 123, title: 'Example task', isDone: false);
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: TaskCard(task: task),
    ));

    await expectLater(
      find.byType(TaskCard),
      matchesGoldenFile('goldens/task_card/not_done.png'),
    );

    // Tap the checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(task.isDone, isTrue);
    await expectLater(
      find.byType(TaskCard),
      matchesGoldenFile('goldens/task_card/done.png'),
    );
  });
}
