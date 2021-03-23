import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';





class IntroScreen extends StatefulWidget {
IntroScreen({Key key}) : super(key: key);

@override
IntroScreenState createState() => new IntroScreenState();
}





class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "",
        description: "HOŞGELDİNİZ",
        pathImage: "",
        backgroundColor: Color(0xff00524E),
      ),
    );
    slides.add(
      new Slide(
        title: "TİTLE",
        description: "DESCRİPTİON",
        pathImage: "",

        backgroundColor: Color(0xff00524E),
      ),
    );
    slides.add(
      new Slide(
        title: "TİTLE",
        description:
        "DESCRİPTİON",
        pathImage: "",

        backgroundColor: Color(0xff00524E),
      ),
    );
  }

  void onDonePress() {
    // Do what you want
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        IntroSlider(
          nameNextBtn: "İLERİ",
          nameSkipBtn: "GEÇ",
          nameDoneBtn: "ÇIKIŞ",
        slides: this.slides,
        onDonePress: this.onDonePress,
      ),
        Positioned(
          top:200,
          left: 170,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("asset/YesilMarker.png")
            )),
          ),
        ),

      ],
    );
  }
}
