import 'package:flutter/material.dart';
import 'appscreens/productlistpage.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildLightThemeData(),
      darkTheme: _buildDarkThemeData(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const ProductListPage(),
    );
  }

  ThemeData _buildLightThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        titleSpacing: 10,
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white.withOpacity(.90),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.white
      ),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.purple,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.purple,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );
  }
  ThemeData _buildDarkThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        titleSpacing: 10,
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.black.withOpacity(.8),
      ),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.purple,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.purple,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );
  }
}
