import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class mlTest extends StatefulWidget {
  @override
  _mlTestState createState() => _mlTestState();
}

class _mlTestState extends State<mlTest> {
  _loadAsset()async{
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

    FirebaseVisionImage image =FirebaseVisionImage.fromFile(File(imageFile.path));
    ImageLabeler label =FirebaseVision.instance.imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.70));

    List<ImageLabel> labels= await label.processImage(image);

    for(ImageLabel label in labels){

      print(label.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: ()async{
         await _loadAsset();
        },
        child: Container(
          child:Center(
            child: Center(child: Text("foto seç"),),
          ),
        ),
      ),
    );
  }
}
