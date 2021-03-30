import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge/features/screen/account/login_screen.dart';
import 'package:solution_challenge/utils/bloc_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solution_challenge/utils/prefLanguage.dart';

class initLanguage extends StatefulWidget {
  @override
  _initLanguageState createState() => _initLanguageState();
}

class _initLanguageState extends State<initLanguage> {
  void initLanguage() async {
    final String language = await PrefUtils.getLanguage();
    BlocProvider.of<BlocLocalization>(context).add(
      language == "tr" ? LocaleEvent.TR : LocaleEvent.EN,
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LoginScreen(),
    ));
  }

  @override
  void initState() {
    initLanguage();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
