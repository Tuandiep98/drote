import 'package:drote/global/locator.dart';
import 'package:drote/global/providers.dart';
import 'package:drote/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

const Color kCanvasColor = Color(0xfff2f3f7);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...viewModelProviders],
      child: MaterialApp(
        title: 'Drote',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
