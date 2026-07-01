import 'package:flutter_test/flutter_test.dart';
import 'package:foodgo/main.dart';

void main() {
  testWidgets('App starts without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodGoApp());
  });
}
