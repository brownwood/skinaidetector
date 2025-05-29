import 'package:flutter/material.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/Images/pg1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFFE3C1A0), // Soft brown shade
                      Colors.transparent, // Fading to transparent
                    ],
                    stops: [0.0, 0.5],
                  ),
                ),
              ),
            ),
            // Text at the bottom
           Positioned(
              bottom: screenHeight * 0.2,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Choose',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight:FontWeight.w500,
                        fontFamily: 'Zolina',
                        color: Colors.black, // Contrasting color for visibility
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Center(
                    child: Text(
                      'Beauty Products',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight:FontWeight.w100,
                        fontFamily: 'Zolina',
                        color: Colors.black, // Contrasting color for visibility
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
