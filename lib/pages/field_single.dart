import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:med/drawer.dart';
import 'package:med/pages/single_word.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/sqlite/db_helper.dart';
import 'package:med/sqlite/word.dart';
import 'package:med/sqlite/field.dart';
import 'word_single.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';

class FieldSingle extends StatefulWidget {
  final int id;
  FieldSingle(this.id);
  @override
  _FieldSingleState createState() => _FieldSingleState();
}

class _FieldSingleState extends State<FieldSingle> {
  List<Word> words = List();
  List<Word> filteredWords = List();
  //DBHelper dbHelper = DBHelper();
  DatabaseHelper dbHelper2 = DatabaseHelper();
  Field foundedField;
  Field field;

  Future<Field> _getField() async {
    print(widget.id);
    field = await dbHelper2.getFieldByID(widget.id);
    return field;
  }

  void initState() {
    super.initState();
    setState(() {
      dbHelper2.getWordsByFieldID(widget.id).then((wordsFromDB) {
        setState(() {
          words = wordsFromDB;
          filteredWords = words;
        });
      });
      dbHelper2.getFieldByID(widget.id).then((field) {
        setState(() {
          foundedField = field;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
          title: FutureBuilder(
              future: _getField(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Text('');
                } else {
                   return Text(languageBloc.isLatvian ? snapshot.data.field : 'English');
                }
              })
          //Text(foundedField.field),
          ),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: languageBloc.isLatvian ? 'Ievadiet vārdu šeit':'Enter word here',
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              prefixIcon: Icon(Icons.search),
              labelText: languageBloc.isLatvian ? 'Meklēt' : 'Search',
            ),
            onChanged: (string) {
              setState(() {
                if (languageBloc.isLatvian) {
                  filteredWords = words
                      .where((u) => (u.wordLV
                          .toLowerCase()
                          .contains(string.toLowerCase())))
                      .toList();
                }else{
                  filteredWords = words
                      .where((u) => (u.wordENG
                      .toLowerCase()
                      .contains(string.toLowerCase())))
                      .toList();
                }
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              //padding: EdgeInsets.all(10.0),
              itemCount: filteredWords.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SingleWord(filteredWords[index].wordID))),
                  child: Card(
                    shape: BeveledRectangleBorder(
                      side: BorderSide(
                        color: Colors.deepPurple,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: languageBloc.isLatvian ? Text(
                            filteredWords[index].wordLV,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ) : Text(
                            filteredWords[index].wordENG,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ) ,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
