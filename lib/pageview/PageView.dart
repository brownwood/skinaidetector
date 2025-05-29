import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intropage1.dart';
import 'intropage2.dart';
import 'intropage3.dart';


class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  final PageController _controller = PageController();
  bool lastPage=false;

 /* void OneTimeScreen()async{
    SharedPreferences onetime= await SharedPreferences.getInstance();
    onetime.setBool('Done', true);
  }*/

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: _controller,
              onPageChanged: (index){
              setState(() {
                lastPage=(index==2);
              });
          },
          children:const [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),
          !lastPage ?  Positioned(
            bottom: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Center(
                      child: GestureDetector(
                        onTap: (){
                          _controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                        },
                        child: Container(
                        width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black,width: 1),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.arrow_forward_ios_outlined),

                        ),
                      ),
                ),
          ) :
          Container(
            margin: const EdgeInsets.only(top: 320),
            alignment: const Alignment(-0.75,0.25),
              child: Column(
                children: [
                  const SizedBox(height: 8,),
                  SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: const SlideEffect(
                        dotHeight: 0.0,
                        dotWidth: 0.0,
                        dotColor: Colors.transparent ,
                          activeDotColor: Colors.transparent
                      ),
                  ),

                ],
              ))
        ]
      ),
    );
  }
}