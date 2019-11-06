import 'package:flutter/material.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';
import 'package:med/drawer.dart';
import 'package:nice_button/nice_button.dart';
import 'fields_for_games.dart';

class GamesList extends StatelessWidget {
  GamesList();
  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: languageBloc.isLatvian ? Text('Izglītojošas spēles') : Text('Educational games'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NiceButton(
                elevation: 8.0,
                radius: 52.0,
                gradientColors: [Colors.cyan, Colors.red],
                text: languageBloc.isLatvian ? ' "Uzraksti pareizi"' : "Writing Game",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FieldsForGamePage(0))),
              ),
              SizedBox(height: 30.0,),
              NiceButton(
                elevation: 8.0,
                radius: 52.0,
                gradientColors: [Colors.blue, Colors.orange],
                text: languageBloc.isLatvian ? ' "Saliec kopā"' : "Matching Game",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FieldsForGamePage(1))),
              ),
              SizedBox(height: 30.0,),
              NiceButton(
                elevation: 8.0,
                radius: 52.0,
                gradientColors: [Colors.yellow, Colors.green],
                text: languageBloc.isLatvian ? ' "Apgriez kārti"' : "Flip Card",
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FieldsForGamePage(2))),
              ),
              SizedBox(height: 30.0,),

            ],
        ),
      ),
    );
  }
}

