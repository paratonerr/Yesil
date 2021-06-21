import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge/features/screen/HomePage_screen.dart';
import 'package:solution_challenge/features/screen/account/login_screen.dart';
import 'package:solution_challenge/features/widgets/HomePage_widget.dart';
import 'package:solution_challenge/utils/bloc_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solution_challenge/utils/prefLanguage.dart';

class initLanguage extends StatefulWidget {
  @override
  _initLanguageState createState() => _initLanguageState();
}

class _initLanguageState extends State<initLanguage> with AfterLayoutMixin<initLanguage>{
 Future  initLanguage() async {
    final String language = await PrefUtils.getLanguage();
    BlocProvider.of<BlocLocalization>(context).add(
      language!=null?language == "tr" ? LocaleEvent.TR : LocaleEvent.EN:LocaleEvent.EN,
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context)async {
    // TODO: implement afterFirstLayout
    await initLanguage().then((value) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => HomePage_Screen(),
      ));
    });

  }
}
