import 'package:final_async/route_generator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: '/recordResponsePage',
      initialRoute: '/cameraTestPage',
      onGenerateRoute: RouteGenerator.generateRoute,
      // home: CameraTestPage(),
    );
  }
}
