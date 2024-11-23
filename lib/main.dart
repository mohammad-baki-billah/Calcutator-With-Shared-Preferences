import 'package:calculator/Theme/theme_changer.dart';
import 'package:calculator/pages/hoem_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeChanger(),
        )
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            themeMode: themeChanger.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              //primarySwatch: Colors.blue,
              
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,

              
              iconButtonTheme:const IconButtonThemeData(
                style: ButtonStyle(
                  iconColor: MaterialStatePropertyAll(Colors.white),

                ),
                
                
                  ),
            ),
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        },
      ),
    );
  }
}
