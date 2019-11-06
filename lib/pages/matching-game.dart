import 'package:flutter/material.dart';
import 'package:med/sqlite/database_helper.dart';
import 'package:med/sqlite/field.dart';
import 'package:med/sqlite/word.dart';
import 'package:med/blocs/language_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';

class MatchingGame extends StatefulWidget {
  final int fieldID;
  MatchingGame(this.fieldID);
  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  int wordsCount;
  var rng = new Random();
  int correctAnswerNumber = 0;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Word> answerVariation = List();

  Future<List<Word>> _getRandomWords() async {
    answerVariation.clear();
    Field field = await dbHelper.getFieldByID(widget.fieldID);
    List<Word> words = await dbHelper.getWordsByFieldID(field.fieldID);
    int wordsCount = words.length;
    List<int> numbers = List();
    correctAnswerNumber = rng.nextInt(4);
    for (var i = 0; i < 4;) {
      var randomNumber = rng.nextInt(wordsCount);
      if (!numbers.contains(randomNumber)) {
        numbers.add(randomNumber);
        answerVariation
            .add(await dbHelper.getWordByID(words[randomNumber].wordID));
        i++;
      }
    }
    return answerVariation;
  }

  Widget instructionText(Word word) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    String type = word.type;
    if (languageBloc.isLatvian) {
      if (type == 'V') {
        return Text(
          'Izvēlieties šim vārdam/frāzei tulkojumu angļu valodā: "' +
              word.wordLV +
              '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'J') {
        return Text(
          'Izvēlieties šim jautājumam tulkojumu angļu valodā: "' +
              word.wordLV +
              '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'N') {
        return Text(
          'Izvēlieties šim norādījumam tulkojumu angļu valodā: "' +
              word.wordLV +
              '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      }
    } else {
      if (type == 'V') {
        return Text(
          'Write this word/phrase in Latvian: "' + word.wordENG + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'J') {
        return Text(
          'Write this question in Latvian: "' + word.wordENG + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      } else if (type == 'N') {
        return Text(
          'Write this instruction in Latvian: "' + word.wordENG + '"',
          style: TextStyle(
            fontSize: 33.0,
          ),
        );
      }
    }
  }

  Word getCorrectAnswer(List<Word> words) {
    var randomNumber = rng.nextInt(4);
    return words[randomNumber];
  }

  Future<bool> checkAnswer(Word answer, Word word) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    if (answer == word) {
      return Alert(
        context: context,
        title: languageBloc.isLatvian ? "Pareizi" : 'Correct Answer',
        type: AlertType.success,
        style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
        ),
        buttons: [
          DialogButton(
            child: Text(
              languageBloc.isLatvian ? "NĀKOŠAIS" : 'NEXT',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WritingGame(widget.fieldID))),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          )
        ],
      ).show();
    } else {
      return Alert(
        context: context,
        title: languageBloc.isLatvian ? "Nepareizi" : 'Wrong Answer',
        type: AlertType.error,
        desc: languageBloc.isLatvian
            ? 'Pareizā atbilde: ' + answer.wordENG
            : 'Correct answer: ' + answer.wordLV,
        style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
        ),
        buttons: [
          DialogButton(
            child: Text(
              languageBloc.isLatvian ? "NĀKOŠAIS" : 'NEXT',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WritingGame(widget.fieldID))),
          )
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = Provider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('"Saliec kopā"'),
        /*
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30.0, 0),
              child: Text('"Saliec kopā"', style: TextStyle(fontSize: 25.0, letterSpacing: 2.0)),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () { },
            child: Icon(Icons.apps, size: 40.0,),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],*/
      ),
      body: Center(
        child: FutureBuilder(
          future: _getRandomWords(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:
                          instructionText(snapshot.data[correctAnswerNumber]),
                    ),
                    new Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: RaisedButton(
                              color: Colors.deepPurple,
                              textColor: Colors.white,
                              onPressed: () {
                                checkAnswer(snapshot.data[correctAnswerNumber],
                                    snapshot.data[index]);
                              },
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(
                                      languageBloc.isLatvian
                                          ? snapshot.data[index].wordENG
                                          : snapshot.data[index].wordLV,
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
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
          },
        ),
      ),
    );
  }
}
