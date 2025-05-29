import 'dart:async';
import 'package:flutter/material.dart';
import '../pageview/PageView.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const PageViewScreen()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
            body: Center(
              child: Stack(
                children: [
                  SizedBox(
                      height: 300,
                      width: 300,
                      child: Image(
                          fit: BoxFit.contain,
                          image: AssetImage('Assets/Images/hydrahublogo.png'))),
                ],
              ),
            )
        ),
      ),
    );
  }
}
