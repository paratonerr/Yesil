import 'dart:ui';


import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:filter_list/filter_list.dart';
import 'package:solution_challenge/features/widgets/appexpansion.dart';
import 'package:solution_challenge/utils/Routes.dart';
import 'package:solution_challenge/utils/app_localizations.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sizer/sizer.dart';



class HomePageWidget extends StatefulWidget {
  final HomePageProvider homePageProvider;

  HomePageWidget({this.homePageProvider}):super();

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
  double ratingValue;
  bool expansionState;



  User user;


  @override
  void initState() {
    // TODO: implement initState
    user= _auth.currentUser;
    expansionState=false;


    ///initail variable
     _homePageProvider=widget.homePageProvider;

    _homePageProvider.pageController = PageController(initialPage: 1, viewportFraction: 0.8)..addListener(()async{

      _homePageProvider.scroll();

      await _homePageProvider.getRating(_homePageProvider.park[_homePageProvider.parkListPosition].title);

      await _homePageProvider.getUserRating(_homePageProvider.park[_homePageProvider.parkListPosition].title,user.uid).then((value) {
        print("user");
      });
    }
    );



    _homePageProvider.filter.add(AppLocalizations.getString('sit_field'));
    _homePageProvider.filter.add(AppLocalizations.getString('accessible'));
    _homePageProvider.filter.add(AppLocalizations.getString('eat'));
    _homePageProvider.filter.add(AppLocalizations.getString('wc'));
    _homePageProvider.filter.add(AppLocalizations.getString('culture'));
    _homePageProvider.filter.add(AppLocalizations.getString('car_park'));



    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

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
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  markers: Set.from(_homePageProvider.markers),
                  onMapCreated: _homePageProvider.onMapCreated,
                  initialCameraPosition: CameraPosition(target: LatLng(41.060701, 29.037435 ),zoom: 12),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top:5.0.h,left: 5.0.w),
                child: Visibility(
                    visible: _homePageProvider.checkMenuVisibility(),
                    child: Stack(
                      children: [
                        InkWell(
                            onTap: (){
                              if(_homePageProvider.expansionState==false){
                                _homePageProvider.expansionTileList.currentState.expand();
                              }else{
                                _homePageProvider.expansionTileList.currentState.collapse();

                              }
                            },
                            child: filterBar()),

                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, AppRoutes.profil);
                          },
                          child: Padding(
                            padding:  EdgeInsets.only(top:0.6.h,left:4.0.w,right: 0),
                            child: Container(
                              child: Icon(Icons.person_rounded),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(offset: Offset(2,2),color: Colors.black26,blurRadius: 20)],
                                  borderRadius: BorderRadius.circular(50)

                              ),
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),

                      ],
                    )),
              ),

              Opacity(
                opacity: _homePageProvider.checkMenuVisibility()==false?1:0.8,
                child: Visibility(
                  visible: expansionState==true?false:true,
                   child:_homePageProvider.park[_homePageProvider.parkListPosition].photo!=null?
                   SlidingUpPanel(
                     borderRadius: BorderRadius.circular(30),
                    onPanelOpened: (){
                      _homePageProvider.panelCheck=true;
                     },
                    onPanelClosed: (){
                      _homePageProvider.panelCheck=false;

                    },
                    controller:_homePageProvider.panelController ,
                 minHeight: 33.0.h,
                 maxHeight: 85.0.h,
                    collapsed: Container(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding:   EdgeInsets.only(top:2.0.h),
                          child: Text('Ayrıntılar için yukarı kaydırınız',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top:Radius.circular(30))
                      ),
                    ),
                    panelBuilder: (scrollCntrl){
                      print(scrollCntrl.initialScrollOffset);
                      return         _homePageProvider.park[_homePageProvider.parkListPosition].photo!=null?

                      SingleChildScrollView(
                          controller: scrollCntrl,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5,
                              sigmaY: 5
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  )
                              ),
                              height:1170,
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

                                      Visibility(
                                        visible: true,
                                        child: Column(children: [
                                          detailInfo( _homePageProvider.parkListPosition),
                                          Padding(
                                            padding:  EdgeInsets.all(8.0),
                                            child: Divider(color: Colors.black45,indent: 30,endIndent: 30,),
                                          ),
                                          SingleChildScrollView(
                                            child: Column(children: [
                                              detailCard(title: AppLocalizations.getString('accessible'),icon: Icons.accessible,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].engellidostu),
                                              SizedBox(height: 30,),
                                              detailCard(title:  AppLocalizations.getString('sport_field'),icon: Icons.fitness_center,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].kosuPark),
                                              SizedBox(height: 30,),
                                              detailCard(title:  AppLocalizations.getString('eat'),icon: Icons.free_breakfast,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].yemeicme),
                                              SizedBox(height: 30,),
                                              detailCard(title:  AppLocalizations.getString('wc'),icon: Icons.wc,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].tuvalet),
                                              SizedBox(height: 30,),
                                              detailCard(title:  AppLocalizations.getString('culture'),icon: Icons.museum,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].kultureloge),
                                              SizedBox(height: 30,),
                                              detailCard(title:  AppLocalizations.getString('car_park'),icon: Icons.directions_car,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].otopark),
                                              SizedBox(height: 30,),
                                              detailCard(title:  AppLocalizations.getString('sit_field'),icon: Icons.airline_seat_recline_normal,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].oturmaalani),
                                            ],),
                                          ),

                                        ],),
                                      ),



                                    ],),

                                  ),

                                ],
                              ) ,


                            ),
                          ),




                      ):Container();

                    },
                  ):Container()
                ),
              ),
              Visibility(
                visible: _homePageProvider.checkMenuVisibility(),
                child: Positioned(
                    bottom: 2.0.h,
                    child: Container(
                      height: 39.0.w,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        key: PageStorageKey('index'),
                        itemCount:_homePageProvider.park.length,
                        itemBuilder: (context, position) {


                          _homePageProvider.parkListPosition = _homePageProvider.pageController.position.minScrollExtent == null ? _homePageProvider.pageController.initialPage.toInt() : _homePageProvider.pageController.page.toInt();

                          return Visibility(
                              visible: expansionState==true?false:true,
                              child: parkListCard(position));
                        },
                        controller: _homePageProvider.pageController,
                      ),
                    )),
              ),

              Positioned(
                top:34,
                left: 100,
                right: 10,
                child:  InkWell(
                  onTap: (){
                    setState(() {
                      _homePageProvider.expansionTileList.currentState.collapse();

                      setState(() {

                      });

                    });

                  },
                  child: Container()
                )

              ),



              Visibility(
                visible: expansionState==true?false:true,
                child: Visibility(
                    visible: _homePageProvider.checkMenuVisibility(),
                    child: zoomButtons()),
              ),
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
            height: Curves.easeInOut.transform(value) * 250.0.h,
            width: Curves.easeInOut.transform(value) * 450.0.h,
            child: widget,
          ),
        );

      },
      child: InkWell(
        onTap: () async{
         await _homePageProvider.moveCamera();
        },
        child:

        _homePageProvider.park[_homePageProvider.parkListPosition].photo!=null?
        Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                height: 405.0.h,
                width: 90.0.w,

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
                        padding:  EdgeInsets.all(3.0.w),
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                 20),
                              image: DecorationImage(
                                  image: NetworkImage(  _homePageProvider.park[_homePageProvider.parkListPosition].photo),
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
                            _homePageProvider.park[_homePageProvider.parkListPosition].title.toUpperCase(),
                            style: TextStyle(
                                fontSize:8.0, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star,color: Colors.orange,size: 18,),
                              Text(_homePageProvider.ortRating.toString(),style: TextStyle(fontSize: 12,color: Colors.grey),),

                            ],
                          ),

                          Row(
                            children: [
                              Icon(Icons.location_on,size: 17,),
                              Text(
                                _homePageProvider.park[_homePageProvider.parkListPosition].description.toUpperCase(),
                                style: TextStyle(
                                    fontSize:8.0, fontWeight: FontWeight.w500,color: Colors.grey),
                              ),
                            ],
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
        ): Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                height: 405.0.h,
                width: 90.0.w,

                child: Container(
                  decoration:
                  BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(-3,3),blurRadius: 20)],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child:Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Gözcü modundan çıkmak için yana kaydırınız',style: TextStyle(color: Colors.grey),),
                          Icon(Icons.chevron_right,color: Colors.grey,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
  Widget filterBar(){
    return   Padding(
      padding:  EdgeInsets.only(left:22.0.w,right: 5.0.w),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        elevation: 20,
        child: Stack(
          children: [
            AppExpansionTile(
              onExpansionChanged: (value){
                setState(() {
                  expansionState=value;
                });
              },
              key: _homePageProvider.expansionTileList,
              backgroundColor: Colors.transparent,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0.sp)
                    ),
                    height: 40.0.h,
                    width: 250.0.w,
                    child:SingleChildScrollView(
                      child: Column(
                        children: [
                          Divider(color: Colors.black38,),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:16.0,left:2),
                                child: FilterButton(icon: Icons.airline_seat_recline_normal,index: 0,homePageProvider: _homePageProvider,select: _homePageProvider.oturmaalani,name1: _homePageProvider.filter[0],),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:5.0,top:16),
                                child: FilterButton(icon: Icons.accessible,index: 1,select: _homePageProvider.engellidostu,name1: _homePageProvider.filter[1],homePageProvider: _homePageProvider,),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:16.0,left:2),
                                child: FilterButton(icon: Icons.free_breakfast,index:2,select: _homePageProvider.yemek,name1: _homePageProvider.filter[2],homePageProvider: _homePageProvider,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:5.0,top:16),
                                child: FilterButton(icon:Icons.wc,select: _homePageProvider.wc,name1: _homePageProvider.filter[3],index: 3,homePageProvider: _homePageProvider,),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:16.0,left:2),
                                child: FilterButton(icon: Icons.museum,select: _homePageProvider.kultureloge,name1: _homePageProvider.filter[4],index: 4,homePageProvider: _homePageProvider,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:5.0,top:16),
                                child: FilterButton(icon: Icons.directions_car,select: _homePageProvider.otopark,name1: _homePageProvider.filter[5],index: 5,homePageProvider: _homePageProvider,),
                              ),
                            ],
                          ),

                        ],
                      ),
                    )
                )
              ],
            ),
            Padding(
              padding:  EdgeInsets.only(left: 4.0.w,right: 4.0.w,top:1.4.w,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Stack(
                    children: [
                      Text(AppLocalizations.getString('filter'),style: TextStyle(color:_homePageProvider.oturmaalani==true||_homePageProvider.otopark==true||_homePageProvider.kultureloge==true||_homePageProvider.yemek==true||_homePageProvider.wc==true||_homePageProvider.engellidostu==true||_homePageProvider.spor==true?Colors.white:Colors.grey),),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,top:2),
                        child: Row(
                          children: [
                            Visibility(
                              visible: _homePageProvider.engellidostu,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.accessible,color:Color(0xff00524E)),
                              ),
                            ),
                            Visibility(
                              visible: _homePageProvider.spor,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.fitness_center,color:Color(0xff00524E)),
                              ),
                            ),
                            Visibility(
                              visible: _homePageProvider.wc,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.wc,color:Color(0xff00524E)),
                              ),
                            ),
                            Visibility(
                              visible: _homePageProvider.yemek,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.free_breakfast,color:Color(0xff00524E)),
                              ),
                            ),
                            Visibility(
                              visible: _homePageProvider.kultureloge,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.museum,color:Color(0xff00524E)),
                              ),
                            ),
                            Visibility(
                              visible: _homePageProvider.otopark,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.directions_car,color:Color(0xff00524E)),
                              ),
                            ),
                            Visibility(
                              visible: _homePageProvider.oturmaalani,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.airline_seat_recline_normal,color:Color(0xff00524E),),
                              ),
                            ),
                          ],),
                      ),
                    ],
                  ),
                  Row(children: [
                    Container(height: 5.0.h,width: 1,color: Colors.grey.shade400,),
                    SizedBox(width: 2.0.w,),
                    Icon(Icons.filter_list,color: Color(0xff545857),),
                  ],)
              ],
              ),
            ),
            Visibility(
              visible: expansionState==true?true:false,
              child: Padding(
                padding:  EdgeInsets.only(top:47.0.h),
                child: InkWell(
                  onTap: (){
                    _homePageProvider.expansionTileList.currentState.collapse();
                    _homePageProvider.checkFilter2();

                  },
                  child: Container(
                    child: Center(child: Text("UYGULA",style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.w700,fontSize: 18.0.sp),)),
                    width: 80.0.w,
                    height: 7.0.h,
                    decoration: BoxDecoration(
                        color: Colors.transparent,

                        borderRadius: BorderRadius.only()
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );




      Padding(
      padding: const EdgeInsets.only(left:10.0,right: 0),
      child: Card(
        elevation: 20,
        child: Stack(
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
                                child: FilterButton(index: 1,select: _homePageProvider.engellidostu,name1: _homePageProvider.filter[1],homePageProvider: _homePageProvider,),
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
                                child: FilterButton(select: _homePageProvider.kultureloge,name1: _homePageProvider.filter[4],index: 4,homePageProvider: _homePageProvider,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:5.0,top:16),
                                child: FilterButton(select: _homePageProvider.otopark,name1: _homePageProvider.filter[5],index: 5,homePageProvider: _homePageProvider,),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:16.0,left:2),
                                child: FilterButton(select: _homePageProvider.oturmaalani,name1: _homePageProvider.filter[6],index: 6,homePageProvider: _homePageProvider,),
                              ),
                            ],
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:40.0,right: 10),
                    child: Text("Filtrelemek için dokunun",style: TextStyle(color: Colors.grey),),
                  ),
                  Container(height: 35,width: 1,color: Colors.grey.shade400,),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.filter_list,color: Color(0xff545857),),
                  ),],
              ),
            ),

          ],
        ),
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
                                      child: FilterButton(index: 1,select: _homePageProvider.engellidostu,name1: _homePageProvider.filter[1],homePageProvider: _homePageProvider,),
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
                                      child: FilterButton(select: _homePageProvider.kultureloge,name1: _homePageProvider.filter[4],index: 4,homePageProvider: _homePageProvider,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:5.0,top:16),
                                      child: FilterButton(select: _homePageProvider.otopark,name1: _homePageProvider.filter[5],index: 5,homePageProvider: _homePageProvider,),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:16.0,left:2),
                                      child: FilterButton(select: _homePageProvider.oturmaalani,name1: _homePageProvider.filter[6],index: 6,homePageProvider: _homePageProvider,),
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
        padding:  EdgeInsets.all(4.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap:()async{
                double screenWidth = MediaQuery.of(context).size.width *
                    MediaQuery.of(context).devicePixelRatio;
                double screenHeight = MediaQuery.of(context).size.height *
                    MediaQuery.of(context).devicePixelRatio;

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
            padding: EdgeInsets.only(top:6.0.h),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:NetworkImage(_homePageProvider.park[_homePageProvider.parkListPosition].photo),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)
                  )
              ),
              height: 25.0.h,
              width: 39.0.w,
            ),
          ),
        ),
        SizedBox(width: 1.0.w,),
        Expanded(
          child: Padding(
            padding:  EdgeInsets.only(top:6.0.h),
            child: Column(
              children: [
                Text(_homePageProvider.park[_homePageProvider.parkListPosition].title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                Padding(
                  padding:  EdgeInsets.only(left:0.0),
                  child:Column(
                    children: [

                      GFRating(
                        value: _homePageProvider.userRating,
                        onChanged: (value)async{
                          setState(() {
                            _homePageProvider.userRating=value;

                          });
                            _homePageProvider.userRating=value;

                          await _homePageProvider.setRating(_homePageProvider.park[_homePageProvider.parkListPosition].title, user.uid, value).then((value) =>print("başarılı"));

                         await _homePageProvider.getRating(_homePageProvider.park[_homePageProvider.parkListPosition].title);
                         await _homePageProvider.getUserRating(_homePageProvider.park[_homePageProvider.parkListPosition].title,user.uid);
                          ratingValue= _homePageProvider.userRating;

    },
                        borderColor: Colors.orange,
                        color: Colors.orange,
                        size: 27,
                      ),
                      Padding(
                        padding:  EdgeInsets.all(2.0.w),
                        child: Text("Park Puanı: "+_homePageProvider.ortRating.toString().trim(),style: TextStyle(color: Colors.grey),),
                      )
                    ],
                  )
                ),
                Padding(
                  padding:  EdgeInsets.only(left:16.0.w),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Expanded(child: Text(_homePageProvider.park[_homePageProvider.parkListPosition].description,style: TextStyle(color: Colors.grey,fontSize: 12),))
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    print(double.parse(_homePageProvider.park[_homePageProvider.parkListPosition].coords1));
                    MapsLauncher.launchCoordinates(
                    double.parse(_homePageProvider.park[_homePageProvider.parkListPosition].coords1),double.parse(_homePageProvider.park[_homePageProvider.parkListPosition].coords2),_homePageProvider.park[_homePageProvider.parkListPosition].title );

                  },
                  child: Padding(
                    padding:  EdgeInsets.only(right:1.0.h),
                    child: Container(
                      child: Center(child: Text(AppLocalizations.getString('take_me_here'),style: TextStyle(color: Colors.white),)),
                      decoration: BoxDecoration(
                          color: Color(0xff00524E),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 40,
                      width: 140,
                    ),
                  ),
                )
              ],
            ),
          ),
        )

      ],
    );
  }

  Widget detailCard({String title, IconData icon,bool enabled}){
   return Padding(
     padding:  EdgeInsets.only(left:5.0.w,right: 5.0.w),
     child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black45,offset: Offset(-2,4),blurRadius: 10)]
        ),
        height: 10.0.h,
        width: 410.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 4.0.w,),
            Icon(icon,color: enabled==false?Colors.grey: Color(0xff00524E),size: 26.0.sp,),
            SizedBox(width: 4.0.w,),
            Expanded(child: Text(title,style: TextStyle(fontSize: 15.0.sp,fontWeight: FontWeight.w500,color: enabled==false?Colors.grey: Color(0xff00524E)),)),
            Padding(
              padding:  EdgeInsets.only(bottom:5.0.h,left: 10.0.w,right: 5.0.w),
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

    await _homePageProvider.getRating(_homePageProvider.park[_homePageProvider.parkListPosition].title);
    await  _homePageProvider.getUserRating(_homePageProvider.park[_homePageProvider.parkListPosition].title,user.uid);


  }

}

class FilterButton extends StatefulWidget {
   FilterButton({
    Key key,
    this.select, this.name1, this.homePageProvider, this.index, this.icon,
  }) : super(key: key);

  bool select;
  final String name1;
  final HomePageProvider homePageProvider;
  final int index;
  final IconData icon;

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
            widget.homePageProvider.oturmaalani==false?widget.homePageProvider.oturmaalani=true:widget.homePageProvider.oturmaalani=false;
            break;
          case 1:
            widget.homePageProvider.engellidostu==false?widget.homePageProvider.engellidostu=true:widget.homePageProvider.engellidostu=false;
            break;
          case 2:
            widget.homePageProvider.yemek==false?widget.homePageProvider.yemek=true:widget.homePageProvider.yemek=false;
            break;
          case 3:
            widget.homePageProvider.wc==false?widget.homePageProvider.wc=true:widget.homePageProvider.wc=false;
            break;
          case 4:
            widget.homePageProvider.kultureloge==false?widget.homePageProvider.kultureloge=true:widget.homePageProvider.kultureloge=false;
            break;
          case 5:
            widget.homePageProvider.otopark==false?widget.homePageProvider.otopark=true:widget.homePageProvider.otopark=false;
            break;

        }


      },
      child: Container(
        decoration: BoxDecoration(
            border:widget.select==true? Border.all(color: Colors.green): Border.all(color: Colors.white),
            boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(2,2),blurRadius: 10)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        height: 50,
        width: 240,
        child:  Center(child: Padding(
          padding: const EdgeInsets.only(left:16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Visibility(
                  visible: widget.select==true?true:false,
                  child: Icon(Icons.check,color: Colors.green)),
              Text(widget.name1,style: TextStyle(fontSize: 10),),
              Container(
                  height: 40,
                  width: 40,
                  child: Icon(widget.icon,color: widget.select==false?Colors.grey:Color(0xff00524E),))
            ],
          ),
        )),
      ),
    );
  }
}


