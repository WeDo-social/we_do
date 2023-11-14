import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_do/components/profile_button.dart';

void main() {
  testWidgets('ProfileButton', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(
        child: ProfileButton(),
      ),
    ));

    await expectLater(
      find.byType(ProfileButton),
      matchesGoldenFile('goldens/profile_button.png'),
    );
  });
}
