# Experiment 4: Setting up Flutter SDK and Creating a Calculator App

## Aim

To set up the *Flutter SDK* and create a simple *Calculator App* that can perform basic arithmetic operations.

## Steps Followed

1. Installed the *Flutter SDK* and configured environment variables.
2. Installed *Android Studio / VS Code* with Flutter and Dart plugins.
3. Created a new Flutter project named *calculator*.
4. Modified the pubspec.yaml file to add the dependency:

   * math_expressions: ^2.5.0 (used for evaluating expressions).
5. Designed the *UI* in main.dart:

   * A Text widget to display the input/output.
   * A GridView for calculator buttons.
   * Buttons styled with different colors for digits, operators, "C" (clear), and "=" (equals).
6. Implemented logic in _CalculatorPageState:

   * *C (Clear):* Clears the display.
   * *=:* Evaluates the typed expression using math_expressions.
   * *+ , - , × , ÷:* Adds operators to the expression.
   * *Digits (0–9):* Appends digits to the expression.
7. Ran and tested the app on an *emulator* and *real device*.

## Source Code

* [main.dart](./lib/main.dart)
* [pubspec.yaml](./pubspec.yaml)

## Expected Output

* *Initial screen:* Shows an empty display with calculator buttons.
* *Press numbers/operators:* Input expression appears on the display.
* *Press "=":* Displays the result of the calculation.
* *Press "C":* Clears the display.
* *Invalid operations (e.g., divide by zero):* Shows "Error"

## Resources

This project is a starting point for a Flutter application.
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,

samples, guidance on mobile development, and a full API reference.
