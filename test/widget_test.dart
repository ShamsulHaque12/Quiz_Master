import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('Quiz App full integration flow test', (WidgetTester tester) async {
    // Set screen size to a comfortable mobile/tablet ratio for the test environment
    tester.view.physicalSize = const Size(600 * 3, 1000 * 3);
    tester.view.devicePixelRatio = 3.0;

    // Reset it after the test finishes
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Verify we are on the Sign-In screen
    expect(find.text('QuizMaster'), findsOneWidget);
    expect(find.text('Elevate Your Knowledge, Master the Challenge'), findsOneWidget);
    expect(find.text('Play as Guest'), findsOneWidget);

    // 2. Scroll and tap on "Play as Guest" to navigate to Dashboard
    await tester.ensureVisible(find.text('Play as Guest'));
    await tester.tap(find.text('Play as Guest'));
    await tester.pumpAndSettle();

    // Verify we are on the Dashboard Home screen
    expect(find.text('Programming\nFundamentals'), findsOneWidget);

    // Tap on the daily challenge card to launch QuizView gameplay
    await tester.tap(find.text('Programming\nFundamentals'));
    await tester.pumpAndSettle();

    // 3. Verify we are on the Quiz screen
    expect(find.text('Quiz Master'), findsOneWidget);
    expect(find.text('Which programming language is used by Flutter?'), findsOneWidget);

    // Verify that the Next Question button is initially disabled
    final nextButtonFinder = find.widgetWithText(ElevatedButton, 'Next Question');
    expect(nextButtonFinder, findsOneWidget);
    expect(tester.widget<ElevatedButton>(nextButtonFinder).enabled, isFalse);

    // Tap on the correct answer "Dart"
    await tester.ensureVisible(find.text('Dart'));
    await tester.tap(find.text('Dart'));
    await tester.pumpAndSettle();

    // Verify that the "Next Question" button is now enabled
    expect(tester.widget<ElevatedButton>(nextButtonFinder).enabled, isTrue);
  });

  testWidgets('Quiz App inline validation test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600 * 3, 1000 * 3);
    tester.view.devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Enter invalid email and tap Sign In
    await tester.enterText(find.byType(TextField).at(0), 'invalid-email');
    await tester.enterText(find.byType(TextField).at(1), '12345');
    final signInButton = find.widgetWithText(InkWell, 'Sign In');
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify email error and password length error
    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    // 2. Clear text fields to verify errors disappear or change
    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify empty errors
    expect(find.text('Email address cannot be empty'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsOneWidget);
  });

  testWidgets('Quiz App sign up validation test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(600 * 3, 1000 * 3);
    tester.view.devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Scroll to and tap on Sign Up prompt to navigate
    final signUpLink = find.descendant(
      of: find.byType(GestureDetector),
      matching: find.text('Sign Up'),
    );
    await tester.ensureVisible(signUpLink);
    await tester.tap(signUpLink);
    await tester.pumpAndSettle();

    // Verify we navigated to Create Account
    expect(find.text('Create Account'), findsOneWidget);

    // 2. Tap on Sign Up button
    final signUpButton = find.widgetWithText(InkWell, 'Sign Up');
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    // Verify the validation errors are shown
    expect(find.text('Full name cannot be empty'), findsOneWidget);
    expect(find.text('Email address cannot be empty'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);

    // 3. Go back to Sign In
    final backButton = find.byIcon(Icons.arrow_back_ios_new_rounded);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Verify we are back on the Sign-In screen
    expect(find.text('QuizMaster'), findsOneWidget);
  });
}
