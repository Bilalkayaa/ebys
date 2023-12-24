import 'package:ebys/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          titleTextStyle:
              TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 4, 245, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(60),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (BuildContext context) => LoginScreen(),
//        "/cart":(BuildContext context) =>CartScreen()
      },
      initialRoute: "/",
    );
  }
}
