// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';

// Import the correct app widget
import 'package:click_pakar/app.dart';

void main() {
  // Ensure the binding is initialized for platform channels/assets
  TestWidgetsFlutterBinding.ensureInitialized();

  // Updated test description to reflect what it actually tests
  testWidgets('GetStartedScreen shows initial text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PediatricPregnancyExpertApp());

    // Wait for async operations (like video initialization) and animations to settle
    await tester.pumpAndSettle();

    // Verify that the main text on the GetStartedScreen is visible
    expect(find.text('Sistem Pakar Medis'), findsOneWidget);

    // Add more checks for other elements on the GetStartedScreen
    expect(find.text('Diagnosa awal penyakit pada Anak & Kehamilan'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
