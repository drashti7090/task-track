import 'package:flutter/material.dart';
import 'package:task_track/splash_screen.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "taskapp",
        // home: SplashScreen(),
        home: SplashScreenApi(),
      )
  );
}
