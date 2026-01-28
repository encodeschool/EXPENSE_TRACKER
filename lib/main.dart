import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('expense_database');
  await Hive.openBox('settings'); // Box for storing theme
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseData()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.grey.shade900,
          secondary: Colors.grey.shade700,
        ),
        scaffoldBackgroundColor: Colors.grey[300],
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.grey.shade100,
          secondary: Colors.grey.shade400,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      ),

      home: const HomePage(),
    );
  }
}
