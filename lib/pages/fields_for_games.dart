import 'package:flutter/material.dart';
import 'package:med/pages/writing-game.dart';
import 'flip-card-game.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/sqlite/field.dart';
import 'package:nice_button/nice_button.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';
import 'matching-game.dart';

class FieldsForGamePage extends StatefulWidget {
  final int gameID;
  FieldsForGamePage(this.gameID);

  @override
  _FieldsForGamePageState createState() => _FieldsForGamePageState();
}

class _FieldsForGamePageState extends State<FieldsForGamePage> {
  List<Field> fields = List();
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Widget> FieldsWidget = List();

  Future<List<Field>> _getFields() async {
    fields = await dbHelper.getFields();
    return fields;
  }


  Widget titleWidget(int id) {
    if (id == 0) {
      final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
      return Column(
        children: <Widget>[
          Text(
            languageBloc.isLatvian
                ? 'Izvēlieties medicīnas nozari: '
                : 'Choose Field of Medicine: ',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      );
    } else {
      return SizedBox(
        height: 15.0,
      );
    }
  }
  Widget gameTitle(){
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    if(languageBloc.isLatvian){
      if(widget.gameID == 0){
        return Text('"Uzraksti pareizi"');
      }
      else if(widget.gameID == 1){
        return Text('"Saliec kopā"');
      }
      else if(widget.gameID == 2){
        return Text('"Apgriez kārti"');
      }
    }else{
      if(widget.gameID == 0){
        return Text('Writing Game');
      }
      else if(widget.gameID == 1){
        return Text('Matching Game');
      }
      else if(widget.gameID == 2){
        return Text('Flip Card');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: gameTitle(),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: FutureBuilder(
            future: _getFields(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text('Loading...'),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        titleWidget(index),
                        NiceButton(
                          elevation: 8.0,
                          width: 400.0,
                          fontSize: 18.0,
                          radius: 52.0,
                          gradientColors: [Colors.blue, Colors.deepPurple],
                          text: languageBloc.isLatvian
                              ? fields[index].field
                              : "Flip Card",
                          onPressed: () {
                            if(widget.gameID == 0){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WritingGame(fields[index].fieldID)));
                            }
                            else if(widget.gameID == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MatchingGame(fields[index].fieldID)));
                            }
                            else if(widget.gameID == 2){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FlipCardGame(fields[index].fieldID)));
                            }
                            }
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
