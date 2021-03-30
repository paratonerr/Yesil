import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solution_challenge/utils/Routes.dart';
import 'package:solution_challenge/utils/app_localizations.dart';

class Profil_Screen extends StatefulWidget {
  @override
  _Profil_ScreenState createState() => _Profil_ScreenState();
}

class _Profil_ScreenState extends State<Profil_Screen>with TickerProviderStateMixin {
  FirebaseAuth _auth;
  User _user;
  GoogleSignIn _googleSignIn=GoogleSignIn();

  TabController tabController;
  PageController pageController;
  List<String> rozet;
  List<String> rozetName;



  _loadAsset()async{
    List<String> responseLabel= [];

    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

    FirebaseVisionImage image =FirebaseVisionImage.fromFile(File(imageFile.path));
    ImageLabeler label =FirebaseVision.instance.imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.70));

    List<ImageLabel> labels= await label.processImage(image);

    for(ImageLabel label in labels){
      responseLabel.add(label.text);
    }

    responseLabel.forEach((element) {
      if(element=='Cat'){
        showDialog(context: context, builder:(context){
          return AlertDialog(title: Text("tebrikler"),);
        });
      }

    });


  }


  @override
  void initState() {
    // TODO: implement initState
    _auth=FirebaseAuth.instance;
     rozet=List<String>();
     rozetName=List<String>();

    rozet.add("asset/1.png");
    rozet.add("asset/2.png");
    rozet.add("asset/3.png");
    rozet.add("asset/4.png");
    rozet.add("asset/5.png");
    rozet.add("asset/6.png");
    rozet.add("asset/7.png");
    rozet.add("asset/8.png");
    rozet.add("asset/9.png");
    rozet.add("asset/10.png");
    rozet.add("asset/11.png");
    rozet.add("asset/12.png");
    rozet.add("asset/13.png");
    rozet.add("asset/14.png");
    rozet.add("asset/15.png");
    
    rozetName.add("title1");
    rozetName.add("title2");
    rozetName.add("title3");
    rozetName.add("title4");
    rozetName.add("title5");
    rozetName.add("title6");
    rozetName.add("title7");
    rozetName.add("title8");
    rozetName.add("title9");
    rozetName.add("title10");
    rozetName.add("title11");
    rozetName.add("title12");
    rozetName.add("title13");
    rozetName.add("title14");
    rozetName.add("title15");

    _user=_auth.currentUser;

    pageController=PageController(initialPage: 1);
    tabController=TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async=> false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              Container(
              height: 260,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                        top:20,
                        left: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap:()async{
                                  await showDialog(context: context,
                                    builder: (context){
                                    return  AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        content: Container(
                                          color: Colors.white,
                                          height: 270,
                                          width: 200,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom:150.0,left: 10,right: 10),
                                                child: Text("Çıkış yapmak istediğinize emin misiniz?",style: TextStyle(fontWeight: FontWeight.w700),),
                                              ),
                                              InkWell(
                                                onTap: ()async{
                                                  _googleSignIn.signOut().then((value) {

                                                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.init_language, (route) => false);

                                                  });

                                                },
                                                child: Container(
                                                  child:Center(child: Text("ÇIKIŞ YAP",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),)),
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 60,
                                                  color: Colors.green.shade700,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  },
                                child: Icon(Icons.login,size: 30,color: Colors.red.shade900,)),
                            SizedBox(width: 50,),
                            Text(_user.email,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                            SizedBox(width: 30,),
                            InkWell(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.clear,size: 30,color: Colors.grey,))
                          ],
                        )),
                    Positioned(
                      left: 116,
                        top:95,
                        child: Container(
                            height: 130,
                            width: 130,
                            child: Image.asset("asset/avatar_daire.png"))),
                    Positioned(
                      top:120,
                      left: MediaQuery.of(context).size.width-219,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(_user.photoURL),

                            ),
                            borderRadius: BorderRadius.circular(150)),
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ],
                ),
              ),
                   TabBar(
                     indicatorColor: Colors.black,
                  controller: tabController,
                  tabs: [
                    Container(
                        height: 50,
                        child: Center(child: Text(AppLocalizations.getString('profile'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),))),
                    Container(
                        height: 50,
                        child: Center(child: Text(AppLocalizations.getString('basarimlar'),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),))),
                  ]),
                   Container(
                width:MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height-190,
                child: TabBarView(
                controller: tabController
                ,children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(padding: EdgeInsets.only(right: 13,top:40),
                          child: Text(AppLocalizations.getString('level'),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),

                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(left: 15,top:0),
                      child:Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:13),
                            child: Container(
                                height: 60,
                                width: 60,
                                child: Image.asset("asset/profil_fidan.png")),
                          ),
                          SizedBox(width: 24,),
                          Expanded(child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.black12,offset: Offset(2,2),blurRadius: 20)]
                            ),
                            child: GFProgressBar(
                              backgroundColor: Colors.white,
                              progressBarColor: Colors.green.shade600,
                              percentage: 0.2,
                              width: 200,
                              radius: 90,
                              lineHeight: 25,
                            ) ,
                          ),

                          )

                        ],
                      )




                      ),
                      Padding(padding: EdgeInsets.only(top:30,bottom: 10),
                     child: Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left:18.0,right: 16),
                           child: Container(
                             child:  Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Row(
                                   children: [
                                     Container(
                                         height: 60,
                                         width: 60,
                                         child: Image.asset("asset/YesilMarker.png")),
                                     SizedBox(width: 20,),
                                     Text("0",style: TextStyle(fontSize: 40,color: Colors.green.shade900,fontWeight: FontWeight.w700),)
                                   ],
                                 ),
                                 SizedBox(height: 10,),
                                 Text(AppLocalizations.getString('green_areas_discovered'),style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700),)
                               ],
                             ),
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(2,2),blurRadius: 10)],

                                 borderRadius: BorderRadius.circular(20)
                             ),
                             height: 130,
                             width: 150,

                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(left:6.0),
                           child: Container(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Row(
                                   children: [
                                     SizedBox(width: 20,),

                                     Container(
                                         height: 50,
                                         width: 50,
                                         child: Image.asset("asset/profil_dag.png")),
                                     SizedBox(width: 20,),
                                     Text("0",style: TextStyle(fontSize: 40,color: Colors.blue.shade900,fontWeight: FontWeight.w700),)
                                   ],
                                 ),
                                 SizedBox(height: 10,),
                                 Text(AppLocalizations.getString('completed_tasks'),style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700),)
                               ],
                             ),
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(2,2),blurRadius: 10)],
                                 borderRadius: BorderRadius.circular(20)
                             ),
                             height: 130,
                             width: 150,

                           ),
                         ),
                       ],
                     )
                       ,

                     ),
                      Padding(padding: EdgeInsets.only(left:20,right:13,top:30),
                      child:    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,

                            boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(2,2),blurRadius: 10)],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        width: double.infinity,
                        height: 80,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: rozet.length,itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  content:Container(
                                    color: Colors.white,
                                    height: 240,
                                    width: 200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom:150.0,left: 10,right: 10),
                                          child: Text("Görev",style: TextStyle(fontWeight: FontWeight.w700),),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex:1,
                                              child: InkWell(
                                                onTap:()async{
                                                  await _loadAsset();
                                                },
                                                child: Container(
                                                  height: 60,
                                                  child:Center(child: Text("BAŞLA",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),)),
                                                  color: Colors.green.shade700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 6,),
                                            Expanded(
                                              flex:1,
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 60,
                                                  child:Center(child: Text("İPTAL",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),)),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );

                              });


                            },
                            child: Padding(padding: EdgeInsets.all(10),
                            child:   Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(rozet[index])
                                ),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              height: 30,
                              width: 60,

                            )

                            ),
                          );



                        }),
                      ))
                    ],
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Column(
                          children: List.generate(rozetName.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(left:10,right:10,top:15),
                              child:            Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:70,
                                        width:70,
                                          child: Image.asset(rozet[index])),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:15.0,bottom:55),
                                      child: Text(rozetName[index],style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.w600),),
                                    )
                                  ],
                                ),
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(2,2),blurRadius: 10)]
                                  ))
                              ,
                            );







                          })
                      ),
                    ),
                  ),
                ],),
              )







            ],),
          ),

        ),
      ),
    );
  }
}
