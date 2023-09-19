import 'package:aigrocery/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var finalColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));

var darkColorSchele =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  ).then(
    (fn) {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData().copyWith(
            useMaterial3: true,
            colorScheme: finalColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: finalColorScheme.onPrimaryContainer,
                foregroundColor: finalColorScheme.primaryContainer),
            cardTheme: const CardTheme().copyWith(
              color: finalColorScheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: finalColorScheme.primaryContainer,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: finalColorScheme.primaryContainer,
              ),
            ),
          ),
          home:  const Expenses(),
        ),
      );
    },
  );
}
