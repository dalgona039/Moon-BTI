import 'package:flutter_test/flutter_test.dart';
import 'package:moonbti/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MoonBtiApp());
    expect(find.text('BTI'), findsOneWidget);
  });
}
