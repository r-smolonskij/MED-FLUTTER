import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:med/drawer.dart';
import 'package:med/pages/single_word.dart';
import 'package:med/pages/word_single.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/sqlite/db_helper.dart';
import 'package:med/sqlite/word.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Word> words = List();
  List<Word> filteredWords = List();
  //DBHelper dbHelper = DBHelper();
  DatabaseHelper dbHelper2 = DatabaseHelper();
  void initState() {
    super.initState();
    setState(() {
      dbHelper2.getWords().then((wordsFromDB) {
        setState(() {
          words = wordsFromDB;
          filteredWords = words;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: new AppBar(
        title: languageBloc.isLatvian ? Text('Vārdu meklēšana') : Text('Search page'),
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
              hintText: languageBloc.isLatvian ? 'Ievadiet šeit vārdu' :'Enter word here',
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              prefixIcon: Icon(Icons.search),
              labelText: languageBloc.isLatvian ? 'Meklēt':'Search',
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
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleWord(filteredWords[index].wordID))),
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
                          child: Text(
                            languageBloc.isLatvian ? filteredWords[index].wordLV : filteredWords[index].wordENG,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
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
