import 'package:flutter_test/flutter_test.dart';
import 'package:lentera/app.dart';

void main() {
  testWidgets('LENTERA shows splash title', (tester) async {
    await tester.pumpWidget(const LenteraApp());
    expect(find.text('LENTERA'), findsOneWidget);
  });
}
