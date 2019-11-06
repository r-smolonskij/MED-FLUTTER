import 'package:flutter/material.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/sqlite/field.dart';
import 'package:med/sqlite/word.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
import 'fields_for_games.dart';

class FlipCardGame extends StatefulWidget {
  final int fieldID;
  FlipCardGame(this.fieldID);

  @override
  _FlipCardGameState createState() => _FlipCardGameState();
}

class _FlipCardGameState extends State<FlipCardGame> {
  Word foundedWord = Word(0, '', '', '');
  Field foundedField = Field(0, '');
  List<Word> foundedWords = List();
  DatabaseHelper dbHelper = DatabaseHelper();
  Random rand = new Random();

  Future<Word> _getWord() async {
    List<Word> words = await dbHelper.getWordsByFieldID(widget.fieldID);
    foundedWord = await dbHelper.getWordByID(words[rand.nextInt(words.length)].wordID);
    return foundedWord;
  }

  @override
  void initState() {
    super.initState();
    dbHelper.getWordsByFieldID(widget.fieldID).then((foundedWords) {
      var randomNumber = rand.nextInt(foundedWords.length);
      foundedWord = foundedWords[randomNumber];
    });
  }

  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languageBloc.isLatvian ? '"Apgriez kārti"' : 'Flip card'),
      ),
      body: Center(
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
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        languageBloc.isLatvian
                            ? 'Apgriez kārti, lai tulkojumu angļu valodā!'
                            : 'Flip card to see translation in Latvian!',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      FlipCard(
                        direction: FlipDirection.HORIZONTAL, // default
                        front: Container(
                          width: 300.0,
                          height: 300.0,
                          color: Colors.deepPurple,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    foundedWord.wordLV,
                                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        back: Container(
                          color: Colors.blue,
                          width: 300.0,
                          height: 300.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    foundedWord.wordENG,
                                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Container(
                        height: 70.0,
                        width: 300.0,
                        child: RaisedButton(
                          color: Colors.green,
                          highlightColor: Colors.yellow,
                          onPressed: (){
                            setState(() {
                              _getWord();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Next', style: TextStyle(color: Colors.white, fontSize: 40.0),),
                              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40.0,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),


    );
  }
}
