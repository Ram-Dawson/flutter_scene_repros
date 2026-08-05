// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_scene_repros/main.dart';

void main() {
  testWidgets('lists only the Rapier snapshot membership case', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter Scene Repros'), findsOneWidget);
    expect(find.text('Rapier Snapshot Membership'), findsOneWidget);
    expect(find.text('Manual state check'), findsOneWidget);
    expect(find.text('Updatable Mesh Shrink'), findsNothing);
  });

  testWidgets('manually exercises the rejected restore path', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rapier Snapshot Membership'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Snapshot world'));
    await tester.pump();
    await tester.tap(find.text('Add body'));
    await tester.pump();

    expect(find.text('Snapshot membership: [A]'), findsOneWidget);
    expect(find.text('Dart registry: [A, B]'), findsOneWidget);
    expect(find.text('Native restore target: [A]'), findsOneWidget);

    await tester.tap(find.text('Restore snapshot'));
    await tester.pump();

    expect(
      find.text(
        'Restore rejected after membership changed; native and Dart remain aligned.',
      ),
      findsOneWidget,
    );
  });
}
