import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';

class HomePageWidget extends StatefulWidget {
  final HomePageProvider homePageProvider;

  HomePageWidget({this.homePageProvider});

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> with AfterLayoutMixin {
  HomePageProvider _homePageProvider;
BitmapDescriptor icon;
String path= "asset/YesilMarker.png";
  int i=0;


  @override
  void initState() {


    // TODO: implement initState

    ///initail variable
     _homePageProvider=widget.homePageProvider;

      _homePageProvider.parkList.forEach((element) async{
       print("2132"+element.coords1);
       _homePageProvider.markers.add(Marker(
           markerId: MarkerId(element.title),
           infoWindow: InfoWindow(title: element.title, snippet: element.description),
           position: LatLng(double.parse(element.coords1),double.parse(element.coords2))));
     });
    _homePageProvider.pageController = PageController(initialPage: 1, viewportFraction: 0.8)..addListener(_homePageProvider.scroll);



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
                  onMapCreated: _homePageProvider.onMapCreated,
                  markers: Set.from(_homePageProvider.markers),
                  initialCameraPosition: CameraPosition(target: LatLng(41.060701, 29.037435 )),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.250,
                minChildSize: 0.250,
                maxChildSize: 0.9,
                builder: (context,scrollCntrl){
                  return SingleChildScrollView(
                      controller: scrollCntrl,
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
                                  Visibility(
                                    visible:_homePageProvider.detailvisiblity ,
                                    child: Column(children: [
                                      detailInfo( _homePageProvider.parkListPosition-1),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Divider(color: Colors.black45,indent: 30,endIndent: 30,),
                                      ),
                                      detailCard(title: "Engelli Dostu",icon: Icons.accessible,enabled: true),
                                      SizedBox(height: 30,),
                                      detailCard(title: "Spor Alanları",icon: Icons.sports,enabled: true),
                                      SizedBox(height: 30,),
                                      detailCard(title: "Çocuk Oyun Alanı",icon: Icons.gamepad_outlined,enabled: false),
                                      SizedBox(height: 30,),
                                      detailCard(title: "  Tuvalet",icon: Icons.wash,enabled: true),


                                    ],),
                                  ),



                                ],),

                              ),

                            ],
                          ) ,


                        ),
                      )



                  );
                },
              ),
              Visibility(
                visible: !_homePageProvider.detailvisiblity,
                child:  Positioned(
                    bottom: 20,
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        itemCount:_homePageProvider.parkList.length,
                        itemBuilder: (context, position) {
                          _homePageProvider.parkListPosition=position;
                          return parkListCard(position);
                        },
                        controller: _homePageProvider.pageController,
                      ),
                    )),),

              Visibility(
                visible: !_homePageProvider.detailvisiblity,
                child:filterBar(),),
              Visibility(visible: !_homePageProvider.detailvisiblity,child: zoomButtons()),
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
        onTap: () {
          _homePageProvider.moveCamera();
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
                                  image: AssetImage("asset/$position.jpg"),
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
    return Positioned(
      top: 40,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              if(_homePageProvider.visibility==false){
                _homePageProvider.visibility=true;
              }else{
                _homePageProvider.visibility=false;
              }
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 76,),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(0,3),blurRadius: 8)],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width-410,
                  child: Icon(Icons.menu,size: 30,color: Color(0xff545857),),
                ),
                SizedBox(width: 10,),

                Container(
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(0,3),blurRadius: 8)],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width-230,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Filtrelemek için dokunun",style: TextStyle(color: Colors.grey),),
                    ),
                    Container(height: 35,width: 1,color: Colors.grey.shade400,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.filter_list,color: Color(0xff545857),),
                    )
                  ],),
                ),

              ],
            ),
          ),
          InkWell(
        ///zaman yetmediği için menüyü localden çektik menüyü normalde böyle değil
            child: Visibility(
         visible: _homePageProvider.visibility,
              child: Padding(

                padding: const EdgeInsets.only(left:150.0),
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("asset/filtre.png")

                    )
                  ),

                ),
              ),
            ),
          )
        ],
      ),
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
            padding: EdgeInsets.only(top:30),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage("asset/$posinited.jpg"),
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
              Text(_homePageProvider.parkList[_homePageProvider.parkListPosition-1].title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
              Padding(
                padding: const EdgeInsets.only(left:40.0),
                child: Row(children: [
                  Icon(Icons.star,color: Colors.amber,),
                  Icon(Icons.star,color: Colors.amber,),
                  Icon(Icons.star,color: Colors.amber,),
                  Icon(Icons.star,color: Colors.amber,),
                  Icon(Icons.star_half_sharp,color: Colors.amber,),
                ],),
              ),
              Padding(
                padding: const EdgeInsets.only(left:40.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    Expanded(child: Text(_homePageProvider.parkList[_homePageProvider.parkListPosition-1].description,style: TextStyle(color: Colors.grey,fontSize: 12),))
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

  }

}
