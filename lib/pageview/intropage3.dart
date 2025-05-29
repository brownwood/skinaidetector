import 'package:flutter/material.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/pageview/Custom_text.dart';
import 'package:skinai/views/home_screen.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
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
              bottom: screenHeight * 0.14,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
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
                  const SizedBox(height: 8,),
                  const Center(
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
                  const SizedBox(height: 10,),
                  Positioned(
                    bottom: screenHeight * 0.1,
                    left: 0,
                    right: 0,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(secondaryColor)
                        ),
                        onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
                    }, child: CustomText(text: "Done", size: 16, fontWeight: FontWeight.w600,color: Colors.black,)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
