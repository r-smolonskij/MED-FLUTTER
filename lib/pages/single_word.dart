import 'package:flutter/material.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/sqlite/db_helper.dart';
import 'package:med/sqlite/field.dart';
import 'package:med/sqlite/word.dart';
import 'package:expandable/expandable.dart';
import 'field_single.dart';
import 'package:flutter/widgets.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';

class SingleWord extends StatefulWidget {
  final int wordID;
  SingleWord(this.wordID);

  @override
  _SingleWordState createState() => _SingleWordState();
}

class _SingleWordState extends State<SingleWord> {
  Word word;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Field> foundedFields;
  List<Widget> relatedFieldsWidget = List();

  Future<Word> _getWord() async {
    print(widget.wordID);
    word = await dbHelper.getWordByID(widget.wordID);
    List<Field> fields = await dbHelper.getFieldsByWordID(widget.wordID);
    print(await 'The man ' + fields.length.toString());
    return word;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      dbHelper.getFieldsByWordID(widget.wordID).then((fieldsFromDB) {
        setState(() {
          foundedFields = fieldsFromDB;
          print('Fields: ' + foundedFields.length.toString());
          returnFields();
        });
      });
    });
  }

  void returnFields() {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    print('related ' + foundedFields.length.toString());
    for (var i = 0; i < foundedFields.length; i++) {
      relatedFieldsWidget.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RaisedButton.icon(
              elevation: 2.0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              color: Colors.white,
              icon: Icon(Icons.open_in_new),
              label: Expanded(
                child: Text(
                  languageBloc.isLatvian ? foundedFields[i].field : foundedFields[i].field + 'ENG' ,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FieldSingle(foundedFields[i].fieldID))),
            ),
          ),
        ),
      );
    }
  }
  String returnWordType(String type, bool language){
    if(language){
      if(type == 'J'){
        return 'Jautājums';
      }
      else if(type =='N'){
        return 'Norādījums';
      }
      else if(type == 'V'){
        return 'Vārds';
      }
    }else{
      if(type == 'J'){
        return 'Question';
      }
      else if(type =='N'){
        return 'Instruction';
      }
      else if(type == 'V'){
        return 'Word';
      }
    }
  }
//1

  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        child: FutureBuilder(
          future: _getWord(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return Container(
                  child:Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Text(
                          languageBloc.isLatvian ? snapshot.data.wordLV : snapshot.data.wordENG,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          returnWordType(snapshot.data.type ,languageBloc.isLatvian),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            RaisedButton.icon(
                              onPressed: () {},
                              elevation: 2.0,
                              shape: new RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              icon: Icon(Icons.volume_up),
                              label: Text(
                                "Latviski",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "LV: " + snapshot.data.wordLV,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "ENG: " + snapshot.data.wordENG,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        ExpandablePanel(
                          collapsed: Row(
                            children: <Widget>[
                              Text('Lasīt vairāk ',
                                  style: TextStyle(fontSize: 18.0)),
                              Icon(Icons.arrow_downward),
                            ],
                          ),
                          expanded: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('Lasīt mazāk ',
                                      style: TextStyle(fontSize: 18.0)),
                                  Icon(Icons.arrow_upward),
                                ],
                              ),
                              Text(
                                'asdasdasdasasdasd asdasdasdas das das das das das das d asd/ sa das das daasdasdasdasasdasd asdasdasdas das das das das das das d asd/ sa das das daasdasdasdasasdasd asdasdasdas das das das das das das d asd/ sa das das da sd/n',
                                softWrap: true,
                              ),
                            ],
                          ),
                          tapHeaderToExpand: true,
                          hasIcon: false,
                          tapBodyToCollapse: true,
                        ),
                        Column(
                          children: relatedFieldsWidget,
                        )
                      ],
                    ),
                  ),
              );
            }
          },
        ),
      ),
    );
  }
}
