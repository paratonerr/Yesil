import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sizer/sizer.dart';



class OnBoardingMissionPage extends StatefulWidget {
  @override
  _OnBoardingMissionPageState createState() => _OnBoardingMissionPageState();
}

class _OnBoardingMissionPageState extends State<OnBoardingMissionPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {

  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,

      pages: [
        PageViewModel(
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 35.0.h,
                width: 60.0.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("asset/walkingman.png")
                  )
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(1.0.w),
                child: Text("In this mission, grab a trash bag and visit your nearest park",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              ),
              InkWell(
                onTap:()=> Navigator.of(context).pop(),
                child: Padding(
                  padding:   EdgeInsets.only(top:3.0.h),
                  child: Container(
                    child: Center(child:Text("Complete Mission! ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:Color(0xffffde6d),

                    ),
                    height: 7.0.h,
                    width: 50.0.w,
                  ),
                ),
              )

            ],
          ),
          title: " ",
          decoration: pageDecoration,
        ),
        PageViewModel(
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 35.0.h,
                width: 60.0.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/coptoplama.png")
                    )
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(1.0.w),
                child: Text("Look around for litter during your walk, and collect them on your bag if you see any!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              ),
              InkWell(
                onTap:()=> Navigator.of(context).pop(),
                child: Padding(
                  padding:   EdgeInsets.only(top:1.0.h),
                  child: Container(
                    child: Center(child:Text("Complete Mission! ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:Color(0xFFffDE6D),

                    ),
                    height: 7.0.h,
                    width: 50.0.w,
                  ),
                ),
              )

            ],
          ),
          title: " ",
          decoration: pageDecoration,
        ),
        PageViewModel(
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 35.0.h,
                width: 60.0.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/takephoto.png")
                    )
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(1.0.w),
                child: Text(" Take a picture of your trash bag by pressing 'Complete mission' below, and claim your reward!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              ),
              InkWell(
                onTap:()=> Navigator.of(context).pop(),
                child: Padding(
                  padding:   EdgeInsets.only(top:2.0.h),
                  child: Container(
                    child: Center(child:Text("Complete Mission! ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:Color(0xFffFDE6D),

                    ),
                    height: 7.0.h,
                    width: 50.0.w,
                  ),
                ),
              )

            ],
          ),
          title: " ",
          decoration: pageDecoration,
        ),




      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}