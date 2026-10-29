import 'package:flutter_test/flutter_test.dart';
import 'package:artbridge/main.dart';

void main() {
  testWidgets('ArtBridge app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ArtBridgeApp());

    expect(find.text('ArtBridge 🎨'), findsOneWidget);
  });
}