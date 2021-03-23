import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:filter_list/filter_list.dart';
import 'package:solution_challenge/features/widgets/appexpansion.dart';

class HomePageWidget extends StatefulWidget {
  final HomePageProvider homePageProvider;

  HomePageWidget({this.homePageProvider});

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}
class parkList {
  final String name;
  final String avatar;
  parkList({this.name, this.avatar});
}
class _HomePageWidgetState extends State<HomePageWidget> with AfterLayoutMixin {
  HomePageProvider _homePageProvider;
  BitmapDescriptor mapMarker;
FirebaseAuth _auth =FirebaseAuth.instance;

  User user;

  @override
  void initState() {
    // TODO: implement initState
    user= _auth.currentUser;



    ///initail variable
     _homePageProvider=widget.homePageProvider;

    _homePageProvider.pageController = PageController(initialPage: 1, viewportFraction: 0.8)..addListener(_homePageProvider.scroll);

    _homePageProvider.filter.add("Spor Alanları");
    _homePageProvider.filter.add("Çocuk Parkı");
    _homePageProvider.filter.add("Yeme İçme");
    _homePageProvider.filter.add("Tuvalet");
    _homePageProvider.filter.add("Bisiklet Yolu");
    _homePageProvider.filter.add("Koşu Parkı");
    _homePageProvider.filter.add(" WI-FI");

    _homePageProvider.checkFilter();




    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Visibility(visible:_homePageProvider.isLoading,child: Center(child: CircularProgressIndicator(backgroundColor:Color(0xff00524E) ,))),
          Visibility(
            visible: !_homePageProvider.isLoading,
            child: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  markers: Set.from(_homePageProvider.markers),
                  onMapCreated: _homePageProvider.onMapCreated,
                  initialCameraPosition: CameraPosition(target: LatLng(41.060701, 29.037435 )),
                ),
              ),
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (value){

                   _homePageProvider.opacity=value.extent+0.1;
                  return  true;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.40,
                  minChildSize: 0.4,
                  maxChildSize: 0.9,
                  builder: (context,scrollCntrl){
                    _homePageProvider.getRating(_homePageProvider.parkList[_homePageProvider.parkListPosition].title);
                    _homePageProvider.getUserRating(_homePageProvider.parkList[_homePageProvider.parkListPosition].title,user.uid).then((value) {

                     });


                    scrollCntrl.addListener(() {

                    });
                    return SingleChildScrollView(
                        controller: scrollCntrl,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 2,
                            sigmaY: 2,
                          ),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: _homePageProvider.opacity,
                            child:   Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )
                              ),
                              height: MediaQuery.of(context).size.height,
                              child:
                              Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      if( _homePageProvider.detailvisiblity==true){
                                        _homePageProvider.detailvisiblity=false;
                                        _homePageProvider.opacity=0.6;
                                      }
                                      else{
                                        _homePageProvider.opacity=1;
                                        _homePageProvider.detailvisiblity=true;
                                      }
                                    },
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          height: 3,
                                          width: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Ayrıntılar için tıklayın ve yukarı kaydırın",style: TextStyle(color: Colors.grey),),
                                      AnimatedOpacity(
                                        opacity:_homePageProvider.opacity ,
                                        duration: Duration(milliseconds: 500),
                                        child: Visibility(
                                          visible: !_homePageProvider.checkMenuVisibility(),
                                          child: Column(children: [
                                            detailInfo( _homePageProvider.parkListPosition),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Divider(color: Colors.black45,indent: 30,endIndent: 30,),
                                            ),
                                            detailCard(title: "Engelli Dostu",icon: Icons.accessible,enabled: true),
                                            SizedBox(height: 30,),
                                            detailCard(title: "Spor Alanları",icon: Icons.sports,enabled: true),
                                            SizedBox(height: 30,),
                                            detailCard(title: "Çocuk Oyun Alanı",icon: Icons.gamepad_outlined,enabled: false),
                                          ],),
                                        ),
                                      ),



                                    ],),

                                  ),

                                ],
                              ) ,


                            ),
                          ),
                        )



                    );
                  },
                ),
              ),
              Positioned(
                  bottom: 20,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: 1.5-_homePageProvider.opacity,
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        itemCount:_homePageProvider.parkList.length,
                        itemBuilder: (context, position) {
                          _homePageProvider.parkListPosition = _homePageProvider.pageController.position.minScrollExtent == null ? _homePageProvider.pageController.initialPage.toInt() : _homePageProvider.pageController.page.toInt();

                          return Visibility(
                              visible: _homePageProvider.checkMenuVisibility(),
                              child: parkListCard(position));
                        },
                        controller: _homePageProvider.pageController,
                      ),
                    ),
                  )),

              Positioned(
                top:34,
                left: 100,
                right: 10,
                child:  InkWell(
                  onTap: (){
                       _homePageProvider.expansionTileList.currentState.collapse();
                     _homePageProvider.checkFilter();



                  },
                  child: Container()
                )

              ),

              Positioned(
              child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: 1.5-_homePageProvider.opacity,
                  child: Visibility(
                      visible: _homePageProvider.checkMenuVisibility(),
                      child: InkWell(
                          onTap: ()async{


                            _homePageProvider.expansionTileList.currentState.expand();



                          },
                          child: filterBar()))),
                ),


              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                  opacity: 1.5-_homePageProvider.opacity,
                  child: Visibility(
                      visible: _homePageProvider.checkMenuVisibility(),
                      child: zoomButtons())),
            ],),
          ),
        ],
      ),
    );
  }

  Widget parkListCard(int position) {
    return AnimatedBuilder(
      animation: _homePageProvider.pageController,
      builder: (context, Widget widget) {
        double value = 1;
        if (_homePageProvider.pageController.position.haveDimensions) {
          value = _homePageProvider.pageController.page - position;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);



        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 135.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );

      },
      child: InkWell(
        onTap: () async{
         await _homePageProvider.moveCamera();
        },
        child: Stack(
          children: [

            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                height: 325.0,
                width: 275.0,

                child: Container(
                  decoration:
                  BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(-3,3),blurRadius: 20)],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left,color: Colors.grey,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                 20),
                              image: DecorationImage(
                                  image: AssetImage("asset/YesilMarker.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _homePageProvider.parkList[_homePageProvider.parkListPosition].title.toUpperCase(),
                            style: TextStyle(
                                fontSize:8.0, fontWeight: FontWeight.w500),
                          ),

                        ],
                      ),
                      Expanded(child: Icon(Icons.chevron_right,color: Colors.grey,)),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget filterBar(){
    return Padding(
      padding: const EdgeInsets.only(left:30.0,right: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(0,3),blurRadius: 8)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            height: 50,
            width: MediaQuery.of(context).size.width-310,
            child: Icon(Icons.menu,size: 30,color: Color(0xff545857),),
          ),
          InkWell(
            onTap: (){
              _homePageProvider.expansionTileList.currentState.collapse();

            },
            child: Card(
              elevation: 10,
              child: Stack(
                children: [
                  AppExpansionTile(
                    key: _homePageProvider.expansionTileList,
                    backgroundColor: Colors.transparent,
                    children: [

                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(20)
                          ),
                          height: 250,
                          width: 250,
                          child:Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:16.0,left:2),
                                    child: FilterButton(index: 0,homePageProvider: _homePageProvider,select: _homePageProvider.spor,name1: _homePageProvider.filter[0],),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:5.0,top:16),
                                    child: FilterButton(index: 1,select: _homePageProvider.cocukPark,name1: _homePageProvider.filter[1],homePageProvider: _homePageProvider,),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:16.0,left:2),
                                    child: FilterButton(index:2,select: _homePageProvider.yemek,name1: _homePageProvider.filter[2],homePageProvider: _homePageProvider,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:5.0,top:16),
                                    child: FilterButton(select: _homePageProvider.wc,name1: _homePageProvider.filter[3],index: 3,homePageProvider: _homePageProvider,),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:16.0,left:2),
                                    child: FilterButton(select: _homePageProvider.bisiklet,name1: _homePageProvider.filter[4],index: 4,homePageProvider: _homePageProvider,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:5.0,top:16),
                                    child: FilterButton(select: _homePageProvider.kosuPark,name1: _homePageProvider.filter[5],index: 5,homePageProvider: _homePageProvider,),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:16.0,left:2),
                                    child: FilterButton(select: _homePageProvider.ethernet,name1: _homePageProvider.filter[6],index: 6,homePageProvider: _homePageProvider,),
                                  ),
                                ],
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Filtrelemek için dokunun",style: TextStyle(color: Colors.grey),),
                      ),
                      Container(height: 35,width: 1,color: Colors.grey.shade400,),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.filter_list,color: Color(0xff545857),),
                      ),],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );






      Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(0,3),blurRadius: 8)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            height: 50,
            width: MediaQuery.of(context).size.width-310,
            child: Icon(Icons.menu,size: 30,color: Color(0xff545857),),
          ),
        ),

        Card(
          elevation: 10,
          child: Stack(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap:(){
                      _homePageProvider.expansionTileList.currentState.collapse();


                    },
                    child: AppExpansionTile(
                      key: _homePageProvider.expansionTileList,
                      backgroundColor: Colors.transparent,
                      children: [

                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(20)
                            ),
                            height: 250,
                            width: 250,
                            child:Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,left:2),
                                      child: FilterButton(index: 0,homePageProvider: _homePageProvider,select: _homePageProvider.spor,name1: _homePageProvider.filter[0],),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:5.0,top:16),
                                      child: FilterButton(index: 1,select: _homePageProvider.cocukPark,name1: _homePageProvider.filter[1],homePageProvider: _homePageProvider,),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,left:2),
                                      child: FilterButton(index:2,select: _homePageProvider.yemek,name1: _homePageProvider.filter[2],homePageProvider: _homePageProvider,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:5.0,top:16),
                                      child: FilterButton(select: _homePageProvider.wc,name1: _homePageProvider.filter[3],index: 3,homePageProvider: _homePageProvider,),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,left:2),
                                      child: FilterButton(select: _homePageProvider.bisiklet,name1: _homePageProvider.filter[4],index: 4,homePageProvider: _homePageProvider,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:5.0,top:16),
                                      child: FilterButton(select: _homePageProvider.kosuPark,name1: _homePageProvider.filter[5],index: 5,homePageProvider: _homePageProvider,),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,left:2),
                                      child: FilterButton(select: _homePageProvider.ethernet,name1: _homePageProvider.filter[6],index: 6,homePageProvider: _homePageProvider,),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Filtrelemek için dokunun",style: TextStyle(color: Colors.grey),),
                      ),
                      Container(height: 35,width: 1,color: Colors.grey.shade400,),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.filter_list,color: Color(0xff545857),),
                      ),],
                  ),
                ],
              )




            ],
          ),
        )

      ],
    );

  }

  Widget zoomButtons(){

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap:()async{
                double screenWidth = MediaQuery.of(context).size.width *
                    MediaQuery.of(context).size.width;
                double screenHeight = MediaQuery.of(context).size.height *
                    MediaQuery.of(context).size.height;

                double middleX = screenWidth / 2;
                double middleY = screenHeight / 2;

                ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());


                var zoomLevel= await _homePageProvider.controller.getZoomLevel();
                zoomLevel +=0.5;
                var d=    await _homePageProvider.controller.getLatLng(screenCoordinate);
                _homePageProvider.controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(zoom: zoomLevel,target:d )
                    )

                );
              },
              child: Container(
                child: Icon(Icons.add),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(50)
                ),
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: ()async{
                double screenWidth = MediaQuery.of(context).size.width *
                    MediaQuery.of(context).devicePixelRatio;
                double screenHeight = MediaQuery.of(context).size.height *
                    MediaQuery.of(context).devicePixelRatio;

                double middleX = screenWidth / 2;
                double middleY = screenHeight / 2;

                ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());


                var zoomLevel= await _homePageProvider.controller.getZoomLevel();
                zoomLevel -=0.5;
                var d=    await _homePageProvider.controller.getLatLng(screenCoordinate);
                _homePageProvider.controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(zoom: zoomLevel,target:d )
                    )

                );
              },
              child: Container(
                child: Icon(Icons.remove),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(50)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailInfo(int posinited){
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child:   Padding(
            padding: EdgeInsets.only(top:30),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage("asset/YesilMarker.png"),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)
                  )
              ),
              height: 160,
              width: 160,
            ),
          ),
        ),
        SizedBox(width: 25,),
        Expanded(
          child: Column(
            children: [
              Text(_homePageProvider.parkList[_homePageProvider.parkListPosition].title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
              Padding(
                padding: const EdgeInsets.only(left:0.0),
                child:Column(
                  children: [
                    GFRating(

                      value: _homePageProvider.userRating,
                      onChanged: (value)async{
                          _homePageProvider.userRating=value;

                        await _homePageProvider.setRating(_homePageProvider.parkList[_homePageProvider.parkListPosition].title, user.uid, value).then((value) =>print("başarılı"));

                       await _homePageProvider.getRating(_homePageProvider.parkList[_homePageProvider.parkListPosition].title);
                       await _homePageProvider.getUserRating(_homePageProvider.parkList[_homePageProvider.parkListPosition].title,user.uid);

    },
                      borderColor: Colors.orange,
                      color: Colors.orange,
                      size: 27,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Park Puanı: "+_homePageProvider.ortRating.toString().trim(),style: TextStyle(color: Colors.grey),),
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left:40.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    Expanded(child: Text(_homePageProvider.parkList[_homePageProvider.parkListPosition].description,style: TextStyle(color: Colors.grey,fontSize: 12),))
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right:16.0),
                child: Container(
                  child: Center(child: Text("Beni buraya götür!",style: TextStyle(color: Colors.white),)),
                  decoration: BoxDecoration(
                      color: Color(0xff00524E),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: 40,
                  width: 140,
                ),
              )
            ],
          ),
        )

      ],
    );
  }

  Widget detailCard({String title, IconData icon,bool enabled}){
   return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black45,offset: Offset(-2,4),blurRadius: 10)]
      ),
      height: 80,
      width: 410,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon,color: enabled==false?Colors.grey: Color(0xff00524E),size: 40,),
            Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: enabled==false?Colors.grey: Color(0xff00524E)),),
            Padding(
              padding: const EdgeInsets.only(bottom:40.0,left: 40),
              child: Container(
                child: Icon(Icons.info_outline,color: Colors.white,),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 24,
                width: 24,
              ),
            )

          ],),
      ),

    );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    // TODO: implement afterFirstLayout

    await _homePageProvider.getRating(_homePageProvider.parkList[_homePageProvider.parkListPosition].title);
    await  _homePageProvider.getUserRating(_homePageProvider.parkList[_homePageProvider.parkListPosition].title,user.uid);




  }

}

class FilterButton extends StatefulWidget {
   FilterButton({
    Key key,
    this.select, this.name1, this.homePageProvider, this.index,
  }) : super(key: key);

  bool select;
  final String name1;
  final HomePageProvider homePageProvider;
  final int index;

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        switch(widget.index){
          case 0:
            widget.homePageProvider.spor==false?widget.homePageProvider.spor=true:widget.homePageProvider.spor=false;
            break;
          case 1:
            widget.homePageProvider.cocukPark==false?widget.homePageProvider.cocukPark=true:widget.homePageProvider.cocukPark=false;
            break;
          case 2:
            widget.homePageProvider.yemek==false?widget.homePageProvider.yemek=true:widget.homePageProvider.yemek=false;
            break;
          case 3:
            widget.homePageProvider.wc==false?widget.homePageProvider.wc=true:widget.homePageProvider.wc=false;
            break;
          case 4:
            widget.homePageProvider.bisiklet==false?widget.homePageProvider.bisiklet=true:widget.homePageProvider.bisiklet=false;
            break;
          case 5:
            widget.homePageProvider.kosuPark==false?widget.homePageProvider.kosuPark=true:widget.homePageProvider.kosuPark=false;
            break;
          case 6:
            widget.homePageProvider.ethernet==false?widget.homePageProvider.ethernet=true:widget.homePageProvider.ethernet=false;
            break;
        }


      },
      child: Container(
        decoration: BoxDecoration(
            border:widget.select==true? Border.all(color: Colors.green): Border.all(color: Colors.white),
            boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(2,2),blurRadius: 10)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        height: 30,
        width: 120,
        child:  Center(child: Padding(
          padding: const EdgeInsets.only(left:16.0),
          child: Row(
            children: [
              Visibility(
                  visible: widget.select==true?true:false,
                  child: Icon(Icons.check,color: Colors.green)),
              Text(widget.name1,style: TextStyle(fontSize: 10),),
            ],
          ),
        )),
      ),
    );
  }
}
