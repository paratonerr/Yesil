import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:solution_challenge/features/screen/HomePage_screen.dart';
import 'package:solution_challenge/utils/Routes.dart';
import 'package:solution_challenge/utils/app_localizations.dart';
import 'package:solution_challenge/utils/bloc_localization.dart';
import 'package:solution_challenge/utils/prefLanguage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn=GoogleSignIn();
  FirebaseAuth _auth=FirebaseAuth.instance;

  List<String> selectedCountList = [];



  Future signIn()async{

    GoogleSignInAccount googleUser=await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =await googleUser.authentication;

    AuthCredential credential =GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);

    await _auth.signInWithCredential(credential);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top:10,right:16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                InkWell(
                    onTap: (){
                      BlocProvider.of<BlocLocalization>(context).add(LocaleEvent.TR);

                    },
                    child: Text("Türkçe",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.grey),)),
                SizedBox(width: 10,),
                Container(width: 2,color: Colors.grey,height: 30,),
                  SizedBox(width: 10,),
                  InkWell(
                      onTap: (){
                        BlocProvider.of<BlocLocalization>(context).add(LocaleEvent.EN);
                      },
                      child: Text("English",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.grey),)),

              ],),
            ),
          ),
          Padding(
          padding: const EdgeInsets.only(top:90.0),
          child: Column(
            children: [
              Container(
                  height: 200,
                  width: 200,
                  child: Image.asset("asset/yesil_yazili_logo.png")),
              SizedBox(height: 70,),
              Center(
                child: InkWell(
                  onTap: ()async{

                 await signIn().then((value) {
                   Navigator.pushNamed(context, AppRoutes.home);
                 });

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(offset: Offset(2,2),color: Colors.grey,blurRadius: 10)]

                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width-60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: 30,
                            width: 30,
                            child: Image.asset("asset/google_icon.png")),
                        Center(child: Text(AppLocalizations.getString('sign_google'),style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade600,fontSize: 18),),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
        ]
      ),

    );
  }
}
